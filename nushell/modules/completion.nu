
def git_checkout_completer [spans: list<string>] {
    let adjusted = ["git", "checkout"] ++ ($spans | skip 1)
    carapace git nushell ...$adjusted | from json
}

def git_merge_completer [spans: list<string>] {
    let adjusted = ["git", "merge"] ++ ($spans | skip 1)
    carapace git nushell ...$adjusted | from json
}

def git_merge_squash_completer [spans: list<string>] {
    let adjusted = ["git", "merge", "--squash"] ++ ($spans | skip 1)
    carapace git nushell ...$adjusted | from json
}

def git_branch_delete_completer [spans: list<string>] {
    let adjusted = ["git", "branch", "-D"] ++ ($spans | skip 1)
    carapace git nushell ...$adjusted | from json
}

def git_reset_hard_completer [spans: list<string>] {
    let adjusted = ["git", "reset", "--hard"] ++ ($spans | skip 1)
    carapace git nushell ...$adjusted | from json
}
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
$env.config.completions.external = {
	enable: true,
	completer: $carapace_completer
}

def "nu-complete zoxide path" [context: string] {
    let parts = $context | str trim --left | split row " " | skip 1 | each { str downcase }
    let completions = (
        ^zoxide query --list --exclude $env.PWD -- ...$parts
            | lines
            | each { |dir|
                if ($parts | length) <= 1 {
                    $dir
                } else {
                    let dir_lower = $dir | str downcase
                    let rem_start = $parts | drop 1 | reduce --fold 0 { |part, rem_start|
                        ($dir_lower | str index-of --range $rem_start.. $part) + ($part | str length)
                    }
                    {
                        value: ($dir | str substring $rem_start..),
                        description: $dir
                    }
                }
            })
    {
        options: {
            sort: false,
            completion_algorithm: substring,
            case_sensitive: false,
        },
        completions: $completions,
    }
}
def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}

