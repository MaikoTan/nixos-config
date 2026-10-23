# fish completions for magpie, taken from `magpie help` and each subcommand's --help.

function __fish_magpie_agents
    printf '%s\n' claude cc codex gemini opencode oc mimocode deveco pi goose cursor zed copilot crush aside
end

function __fish_magpie_models
    magpie models 2>/dev/null | string replace -rf '^\s+(\S+/\S+).*' '$1' | string match -rv '\s'
end

function __fish_magpie_groups
    __fish_magpie_models | string match -r '^group/.*'
end

function __fish_magpie_providers
    __fish_magpie_models | string replace -rf '^([^/]+)/.*' '$1' | string match -rv '^(group|auto)$' | string match -r '^[a-z0-9][a-z0-9._-]*$' | sort -u
end

complete -c magpie -f

# Top-level commands
complete -c magpie -n __fish_use_subcommand -a ls -d 'Agents found and their settings'
complete -c magpie -n __fish_use_subcommand -a agents -d 'Every agent magpie supports'
complete -c magpie -n __fish_use_subcommand -a models -d 'Every model an agent can pick'
complete -c magpie -n __fish_use_subcommand -a visible -d 'The models an agent is shown'
complete -c magpie -n __fish_use_subcommand -a providers -d 'Your providers: host, key, models, who uses them'
complete -c magpie -n __fish_use_subcommand -a presets -d 'The vendors magpie knows'
complete -c magpie -n __fish_use_subcommand -a provider -d 'Add, change or remove a provider'
complete -c magpie -n __fish_use_subcommand -a import -d 'Add the provider a magpie://import link describes'
complete -c magpie -n __fish_use_subcommand -a groups -d 'Routing groups'
complete -c magpie -n __fish_use_subcommand -a group -d 'Add, change or remove a routing group'
complete -c magpie -n __fish_use_subcommand -a model -d 'A model name or its reasoning levels'
complete -c magpie -n __fish_use_subcommand -a accounts -d 'Every subscription magpie knows'
complete -c magpie -n __fish_use_subcommand -a quota -d 'What is left of every subscription and balance'
complete -c magpie -n __fish_use_subcommand -a usage -d 'Tokens and cost per agent and model'
complete -c magpie -n __fish_use_subcommand -a sessions -d 'What each session cost'
complete -c magpie -n __fish_use_subcommand -a statusline -d "One line for Claude Code's status line"
complete -c magpie -n __fish_use_subcommand -a search -d 'A web search API for when no provider can search'
complete -c magpie -n __fish_use_subcommand -a library -d 'Instructions, MCP servers and skills written into every agent'
complete -c magpie -n __fish_use_subcommand -a plugin -d 'OpenCode provider plugins and pi packages'
complete -c magpie -n __fish_use_subcommand -a claude-code -d 'The Claude Code a Claude subscription runs'
complete -c magpie -n __fish_use_subcommand -a sync -d 'Refresh the model catalog and vendor model lists'
complete -c magpie -n __fish_use_subcommand -a serve -d 'Run the gateway alone'
complete -c magpie -n __fish_use_subcommand -a daemon -d 'magpie serve as a service of yours'
complete -c magpie -n __fish_use_subcommand -a healthcheck -d 'Exit 0 when the gateway answers'
complete -c magpie -n __fish_use_subcommand -a heap -d 'A Go heap profile of the running magpie'
complete -c magpie -n __fish_use_subcommand -a cpu -d 'A Go CPU profile of the running magpie'
complete -c magpie -n __fish_use_subcommand -a gateway-key -d 'The keys clients use to call a shared gateway'
complete -c magpie -n __fish_use_subcommand -a mcp -d 'The image and video generation MCP server'
complete -c magpie -n __fish_use_subcommand -a backup -d 'Providers, keys and settings in one sealed file'
complete -c magpie -n __fish_use_subcommand -a restore -d 'Put a backup in on this machine'
complete -c magpie -n __fish_use_subcommand -a webdav -d 'Keep the same through a WebDAV folder'
complete -c magpie -n __fish_use_subcommand -a s3 -d 'Keep the same through an S3-compatible bucket'
complete -c magpie -n __fish_use_subcommand -a github -d 'Keep the same in an encrypted GitHub repository'
complete -c magpie -n __fish_use_subcommand -a tui -d 'The app, in the terminal'
complete -c magpie -n __fish_use_subcommand -a web -d "The app's window in a browser"
complete -c magpie -n __fish_use_subcommand -a tray -d 'Start in the menu bar only'
complete -c magpie -n __fish_use_subcommand -a panel -d "Open or close the menu bar icon's quick panel"
complete -c magpie -n __fish_use_subcommand -a autostart -d 'Open magpie when you log in'
complete -c magpie -n __fish_use_subcommand -a save -d "Snapshot every agent's settings as a profile"
complete -c magpie -n __fish_use_subcommand -a use -d 'Apply a profile'
complete -c magpie -n __fish_use_subcommand -a profiles -d 'List profiles'
complete -c magpie -n __fish_use_subcommand -a rm -d 'Delete a profile'
complete -c magpie -n __fish_use_subcommand -a update -d 'Install the newest release'

# magpie <agent> <model|field> <value>
complete -c magpie -n __fish_use_subcommand -a '(__fish_magpie_agents)' -d agent
complete -c magpie -f -n '__fish_seen_subcommand_from claude cc codex gemini opencode oc mimocode deveco pi goose cursor zed copilot crush aside' -a '(__fish_magpie_models)'
complete -c magpie -f -n '__fish_seen_subcommand_from claude cc codex gemini opencode oc mimocode deveco pi goose cursor zed copilot crush aside' -a default -d 'Take magpie out of the agent'

# provider
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a add -d 'A preset and its key, or a custom vendor'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a key -d 'Change its key'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a models -d 'Choose which models to expose'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a test -d 'Test it'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a rm -d 'Remove it'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and not __fish_seen_subcommand_from add key models test rm fallback' -a fallback -d 'Use these when it is out of quota or down'
complete -c magpie -f -n '__fish_seen_subcommand_from provider; and __fish_seen_subcommand_from key models test rm fallback' -a '(__fish_magpie_providers)'

# group
complete -c magpie -f -n __fish_use_subcommand -a '(__fish_magpie_groups)' -d 'Routing group'
complete -c magpie -f -n '__fish_seen_subcommand_from group' -a add -d 'Make a group'
complete -c magpie -f -n '__fish_seen_subcommand_from group' -a set -d 'Change one'
complete -c magpie -f -n '__fish_seen_subcommand_from group' -a rm -d 'Remove one'
complete -c magpie -f -n '__fish_seen_subcommand_from group' -a pick -d 'Route the group to one of its models'
complete -c magpie -f -n '__fish_seen_subcommand_from group; and __fish_seen_subcommand_from set rm pick' -a '(__fish_magpie_groups)'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'routing=' -d 'How requests pick a model'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'stays=' -d 'How long one account keeps serving'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'models=' -d 'The whole list, in order, patterns too'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'models+=' -d 'Append models'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'models-=' -d 'Drop models'
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a 'name= context= levels= family= id= effort= classifier= pick= fast= weight= listed='
complete -c magpie -f -n '__fish_seen_subcommand_from set' -a '(__fish_magpie_models)'

# model
complete -c magpie -f -n '__fish_seen_subcommand_from model' -a name -d 'The name a model goes by, everywhere'
complete -c magpie -f -n '__fish_seen_subcommand_from model' -a efforts -d 'The reasoning levels a model offers'
complete -c magpie -f -n '__fish_seen_subcommand_from model; and __fish_seen_subcommand_from name efforts' -a '(__fish_magpie_models)'

# Actions of the remaining subcommands
complete -c magpie -f -n '__fish_seen_subcommand_from daemon' -a 'install uninstall start stop restart status web'
complete -c magpie -f -n '__fish_seen_subcommand_from gateway-key' -a 'list add rotate remove limit models quotas'
complete -c magpie -f -n '__fish_seen_subcommand_from webdav s3 github' -a 'on set now off'
complete -c magpie -f -n '__fish_seen_subcommand_from library' -a 'sync instructions mcp skill'
complete -c magpie -f -n '__fish_seen_subcommand_from search' -a 'add rm'
complete -c magpie -f -n '__fish_seen_subcommand_from accounts' -a 'add import discovery switch refresh checkin project alias switch-only'
complete -c magpie -f -n '__fish_seen_subcommand_from quota' -a 'wait history'
complete -c magpie -f -n '__fish_seen_subcommand_from update' -a 'check mirror auto'
complete -c magpie -f -n '__fish_seen_subcommand_from claude-code' -a 'install remove'
complete -c magpie -f -n '__fish_seen_subcommand_from plugin' -a 'add rm update on off login logout move migrate'

# Common options
complete -c magpie -l json -d 'JSON output'
complete -c magpie -l csv -d 'CSV output'
complete -c magpie -l days -d 'How many days back'
complete -c magpie -l last -d 'A window ending now'
complete -c magpie -l model -d 'Only this model'
complete -c magpie -l folder -d 'Only this folder'
complete -c magpie -l account -d 'Only this account'
complete -c magpie -l web -d 'The service serves the page too'
complete -c magpie -l lan -d 'Reachable over the LAN'
complete -c magpie -l addr -d 'The address to listen on'
complete -c magpie -l no-open -d 'Do not open a browser'
complete -c magpie -l gateway -d 'Gateway mode, no agents'
complete -c magpie -l tls-cert -d 'TLS certificate'
complete -c magpie -l tls-key -d 'TLS key'
complete -c magpie -l proxy -d 'A proxy for the update'
complete -c magpie -l mirror -d 'A GitHub download mirror'
complete -c magpie -l yes -s y -d 'Answer yes'
complete -c magpie -l quiet -d 'Say nothing but the answer'
complete -c magpie -l timeout -d 'How long to wait'
complete -c magpie -l seconds -d 'Seconds to profile'
complete -c magpie -l no-keys -d 'Backup without the keys'
complete -c magpie -l no-library -d 'Backup without the library'
complete -c magpie -l no-agents -d 'Restore without touching agents'
