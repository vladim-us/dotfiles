import os
from collections import namedtuple

import yaml
from boscli.basic_types import OptionsType
from nxops.infrastructure.nxops_command import NxOpsCommand

ConnectionInfo = namedtuple("ConnectionInfo", ["host", "port", "db", "snowflake"])
RedisConnectionInfo = namedtuple("RedisConnectionInfo", ["host", "port"])


def add_configuration_commands(conf_cli, add_command):
    add_command(
        NxOpsCommand(
            ["db", "set", OptionsType(["production", "sandbox"])],
            conf_cli.change_aurora_environment,
            help="Set the aurora environment",
        )
    )
    add_command(
        NxOpsCommand(
            ["db", "show"], conf_cli.dump, help="Show the aurora conf and credentials"
        )
    )


class ConfigurationCli:
    def __init__(self, conf, calculate_prompt_funct):
        self._calculate_prompt_funct = calculate_prompt_funct
        self._conf = conf

    def change_aurora_environment(self, environment, interpreter, *args, **kwargs):
        self._conf.set_aurora_environment(environment)
        interpreter.prompt = self._calculate_prompt_funct(self._conf)

    def dump(self, *args, **kwargs):
        print("env:", self._conf.aurora_environment())
        print("user:", self._conf.aurora_user())
        print("pass:", "*" * len(self._conf.aurora_password()))


class Configuration:
    def __init__(self, base_path):
        self._base_path = base_path
        self._environment = os.environ.get("ENVIRONMENT", "production")
        self._aurora_environment = self._environment
        self._aurora_user = os.environ.get("AURORA_DB_USER", None)
        self._aurora_password = os.environ.get("AURORA_DB_PASSWORD", None)
        self._aurora_write_user = os.environ.get("AURORA_WRITE_DB_USER", None)
        self._aurora_write_password = os.environ.get("AURORA_WRITE_DB_PASSWORD", None)
        self._snowflake_user = os.environ.get("NX_SNOWFLAKE_USER", None)
        self._snowflake_private_key_b64 = os.environ.get(
            "NX_SNOWFLAKE_PRIVATE_KEY_B64", None
        )
        self._snowflake_private_key_passphase = os.environ.get(
            "NX_SNOWFLAKE_PRIVATE_KEY_PASSPHRASE", None
        )
        self._snowflake_warehouse = os.environ.get("NX_SNOWFLAKE_WAREHOUSE", None)
        self._snowflake_database = os.environ.get("NX_SNOWFLAKE_DATABASE", None)
        self._snowflake_role = os.environ.get("NX_SNOWFLAKE_ROLE", None)
        self._slack_api_token = os.environ.get("SLACK_API_TOKEN", None)

        self._operational_status_user = None
        self._operational_status_password = None
        self._operational_status_host = None

        self._airtable_base = os.environ.get("AIRTABLE_BASE", None)
        self._airtable_key = os.environ.get("AIRTABLE_KEY", None)
        self._slack_verification_token = {
            "nxops": os.environ.get("SLACK_VERIFICATION_TOKEN", None)
        }
        self._load_conf_info()

    def _load_conf_info(self):
        path = os.path.join(self._base_path, "conf.yml")
        with open(path) as fh:
            info = yaml.safe_load(fh.read())
            self._operational_status_user = info["operational_status"]["db"]["user"]
            self._operational_status_password = info["operational_status"]["db"][
                "password"
            ]
            self._operational_status_host = info["operational_status"]["db"]["host"]
            self._opsgenie_key = info["opsgenie"]["key"]
            self._airtable_base = (
                info["airtable"]["base"]
                if not self._airtable_base
                else self._airtable_base
            )
            self._airtable_key = (
                info["airtable"]["key"]
                if not self._airtable_key
                else self._airtable_key
            )

    def environment(self):
        return self._environment

    def slack_api_token(self):
        return self._slack_api_token

    def opsgenie_key(self):
        return self._opsgenie_key

    def slack_verification_token(self, appname):
        return self._slack_verification_token.get(appname)

    def airtable_base(self):
        return self._airtable_base

    def airtable_key(self):
        return self._airtable_key

    def operational_status_user(self):
        return self._operational_status_user

    def operational_status_password(self):
        return self._operational_status_password

    def operational_status_host(self):
        return self._operational_status_host

    def is_snowflake_client(self, client, environment=None):
        if environment is None:
            environment = self._environment
        client_info = self.aurora_client_info(client, environment)
        return client_info.snowflake

    def is_evo_mode(self, client):
        return client.endswith("evo")

    def aurora_environment(self):
        return self._aurora_environment

    def user_identification(self):
        if not self.aurora_user():
            return "unknown"
        return self.aurora_user().replace("_read", "")

    def aurora_user(self):
        return self._aurora_user

    def aurora_password(self):
        return self._aurora_password

    def aurora_write_user(self):
        return self._aurora_write_user

    def aurora_write_password(self):
        return self._aurora_write_password

    def snowflake_configuration(self):
        if not self._snowflake_database:
            return False
        if (
            not self._snowflake_user
            or not self._snowflake_private_key_b64
            or not self._snowflake_private_key_passphase
        ):
            return False
        return True

    def aurora_clusters_urls_all_environments(self):
        aurora_info = self._aurora_info_all_environments()
        clusters = []
        for environment in aurora_info.keys():
            for cluster_key in aurora_info[environment].keys():
                cluster_info = aurora_info[environment][cluster_key]
                clusters.append(cluster_info["url"])

        return clusters

    def aurora_clusters_urls_sandbox_environments(self):
        aurora_info = self._aurora_info_all_environments()
        clusters = []
        for cluster_key in aurora_info["sandbox"].keys():
            cluster_info = aurora_info["sandbox"][cluster_key]
            clusters.append(cluster_info["url"])

        return clusters

    def aurora_clusters(self):
        aurora_info = self._aurora_info(self._aurora_environment)
        return [cluster for cluster in aurora_info.keys()]

    def aurora_cluster_info(self, cluster):
        aurora_info = self._aurora_info(self._aurora_environment)
        return aurora_info[cluster]

    def aurora_client_info(self, client, environment=None):
        if environment is None:
            environment = self._aurora_environment
        aurora_info = self._aurora_info(environment)
        clusters_info = self._clusters_info(environment)
        for cluster in clusters_info.keys():
            if client in clusters_info[cluster]:
                client_info = aurora_info[cluster]
                return ConnectionInfo(
                    client_info["url"],
                    client_info["port"],
                    client + "db",
                    client_info.get("snowflake", 0),
                )
        return None

    def redis_connection_info(self, namespace):
        path = os.path.join(self._base_path, "conf.yml")
        with open(path) as fh:
            info = yaml.safe_load(fh.read())["redis"][namespace]
            return RedisConnectionInfo(info["host"], info["port"])

    def clients(self, environment=None):
        environment = environment or self._aurora_environment
        clients = []
        clusters_info = self._clusters_info(environment)
        for cluster in clusters_info.keys():
            clients.extend(clusters_info[cluster])
        return clients

    def dipap_operational_api_host(self, environment):
        return self._dipap_info()[environment]["operational_api"]["host"]

    def _clusters_info(self, namespace):
        path = os.path.join(self._base_path, "clusters.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())[namespace]

    def _aurora_info(self, namespace):
        path = os.path.join(self._base_path, "aurora.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())[namespace]

    def _aurora_info_all_environments(self):
        path = os.path.join(self._base_path, "aurora.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())

    def _dipap_info(self):
        path = os.path.join(self._base_path, "dipap.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())

    def set_aurora_user(self, user):
        self._aurora_user = user

    def set_aurora_password(self, password):
        self._aurora_password = password

    def set_aurora_environment(self, aurora_environment):
        self._aurora_environment = aurora_environment


ConnectionInfo = namedtuple("ConnectionInfo", ["host", "port", "db", "snowflake"])
RedisConnectionInfo = namedtuple("RedisConnectionInfo", ["host", "port"])


def add_configuration_commands(conf_cli, add_command):
    add_command(
        NxOpsCommand(
            ["db", "set", OptionsType(["production", "sandbox"])],
            conf_cli.change_aurora_environment,
            help="Set the aurora environment",
        )
    )
    add_command(
        NxOpsCommand(
            ["db", "show"], conf_cli.dump, help="Show the aurora conf and credentials"
        )
    )


class ConfigurationCli:
    def __init__(self, conf, calculate_prompt_funct):
        self._calculate_prompt_funct = calculate_prompt_funct
        self._conf = conf

    def change_aurora_environment(self, environment, interpreter, *args, **kwargs):
        self._conf.set_aurora_environment(environment)
        interpreter.prompt = self._calculate_prompt_funct(self._conf)

    def dump(self, *args, **kwargs):
        print("env:", self._conf.aurora_environment())
        print("user:", self._conf.aurora_user())
        print("pass:", "*" * len(self._conf.aurora_password()))


class Configuration:
    def __init__(self, base_path):
        self._base_path = base_path
        self._environment = os.environ.get("ENVIRONMENT", "production")
        self._aurora_environment = self._environment
        self._aurora_user = os.environ.get("AURORA_DB_USER", None)
        self._aurora_password = os.environ.get("AURORA_DB_PASSWORD", None)
        self._aurora_write_user = os.environ.get("AURORA_WRITE_DB_USER", None)
        self._aurora_write_password = os.environ.get("AURORA_WRITE_DB_PASSWORD", None)
        self._snowflake_user = os.environ.get("NX_SNOWFLAKE_USER", None)
        self._snowflake_private_key_b64 = os.environ.get(
            "NX_SNOWFLAKE_PRIVATE_KEY_B64", None
        )
        self._snowflake_private_key_passphase = os.environ.get(
            "NX_SNOWFLAKE_PRIVATE_KEY_PASSPHRASE", None
        )
        self._snowflake_warehouse = os.environ.get("NX_SNOWFLAKE_WAREHOUSE", None)
        self._snowflake_database = os.environ.get("NX_SNOWFLAKE_DATABASE", None)
        self._snowflake_role = os.environ.get("NX_SNOWFLAKE_ROLE", None)
        self._slack_api_token = os.environ.get("SLACK_API_TOKEN", None)

        self._operational_status_user = None
        self._operational_status_password = None
        self._operational_status_host = None

        self._airtable_base = os.environ.get("AIRTABLE_BASE", None)
        self._airtable_key = os.environ.get("AIRTABLE_KEY", None)
        self._slack_verification_token = {
            "nxops": os.environ.get("SLACK_VERIFICATION_TOKEN", None)
        }
        self._load_conf_info()

    def _load_conf_info(self):
        path = os.path.join(self._base_path, "conf.yml")
        with open(path) as fh:
            info = yaml.safe_load(fh.read())
            self._operational_status_user = info["operational_status"]["db"]["user"]
            self._operational_status_password = info["operational_status"]["db"][
                "password"
            ]
            self._operational_status_host = info["operational_status"]["db"]["host"]
            self._opsgenie_key = info["opsgenie"]["key"]
            self._airtable_base = (
                info["airtable"]["base"]
                if not self._airtable_base
                else self._airtable_base
            )
            self._airtable_key = (
                info["airtable"]["key"]
                if not self._airtable_key
                else self._airtable_key
            )

    def environment(self):
        return self._environment

    def slack_api_token(self):
        return self._slack_api_token

    def opsgenie_key(self):
        return self._opsgenie_key

    def slack_verification_token(self, appname):
        return self._slack_verification_token.get(appname)

    def airtable_base(self):
        return self._airtable_base

    def airtable_key(self):
        return self._airtable_key

    def operational_status_user(self):
        return self._operational_status_user

    def operational_status_password(self):
        return self._operational_status_password

    def operational_status_host(self):
        return self._operational_status_host

    def is_snowflake_client(self, client, environment=None):
        if environment is None:
            environment = self._environment
        client_info = self.aurora_client_info(client, environment)
        return client_info.snowflake

    def is_evo_mode(self, client):
        return client.endswith("evo")

    def aurora_environment(self):
        return self._aurora_environment

    def user_identification(self):
        if not self.aurora_user():
            return "unknown"
        return self.aurora_user().replace("_read", "")

    def aurora_user(self):
        return self._aurora_user

    def aurora_password(self):
        return self._aurora_password

    def aurora_write_user(self):
        return self._aurora_write_user

    def aurora_write_password(self):
        return self._aurora_write_password

    def snowflake_configuration(self):
        if not self._snowflake_database:
            return False
        if (
            not self._snowflake_user
            or not self._snowflake_private_key_b64
            or not self._snowflake_private_key_passphase
        ):
            return False
        return True

    def aurora_clusters_urls_all_environments(self):
        aurora_info = self._aurora_info_all_environments()
        clusters = []
        for environment in aurora_info.keys():
            for cluster_key in aurora_info[environment].keys():
                cluster_info = aurora_info[environment][cluster_key]
                clusters.append(cluster_info["url"])

        return clusters

    def aurora_clusters_urls_sandbox_environments(self):
        aurora_info = self._aurora_info_all_environments()
        clusters = []
        for cluster_key in aurora_info["sandbox"].keys():
            cluster_info = aurora_info["sandbox"][cluster_key]
            clusters.append(cluster_info["url"])

        return clusters

    def aurora_clusters(self):
        aurora_info = self._aurora_info(self._aurora_environment)
        return [cluster for cluster in aurora_info.keys()]

    def aurora_cluster_info(self, cluster):
        aurora_info = self._aurora_info(self._aurora_environment)
        return aurora_info[cluster]

    def aurora_client_info(self, client, environment=None):
        if environment is None:
            environment = self._aurora_environment
        aurora_info = self._aurora_info(environment)
        clusters_info = self._clusters_info(environment)
        for cluster in clusters_info.keys():
            if client in clusters_info[cluster]:
                client_info = aurora_info[cluster]
                return ConnectionInfo(
                    client_info["url"],
                    client_info["port"],
                    client + "db",
                    client_info.get("snowflake", 0),
                )
        return None

    def redis_connection_info(self, namespace):
        path = os.path.join(self._base_path, "conf.yml")
        with open(path) as fh:
            info = yaml.safe_load(fh.read())["redis"][namespace]
            return RedisConnectionInfo(info["host"], info["port"])

    def clients(self, environment=None):
        environment = environment or self._aurora_environment
        clients = []
        clusters_info = self._clusters_info(environment)
        for cluster in clusters_info.keys():
            clients.extend(clusters_info[cluster])
        return clients

    def dipap_operational_api_host(self, environment):
        return self._dipap_info()[environment]["operational_api"]["host"]

    def _clusters_info(self, namespace):
        path = os.path.join(self._base_path, "clusters.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())[namespace]

    def _aurora_info(self, namespace):
        path = os.path.join(self._base_path, "aurora.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())[namespace]

    def _aurora_info_all_environments(self):
        path = os.path.join(self._base_path, "aurora.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())

    def _dipap_info(self):
        path = os.path.join(self._base_path, "dipap.yml")
        with open(path) as fh:
            return yaml.safe_load(fh.read())

    def set_aurora_user(self, user):
        self._aurora_user = user

    def set_aurora_password(self, password):
        self._aurora_password = password

    def set_aurora_environment(self, aurora_environment):
        self._aurora_environment = aurora_environment
