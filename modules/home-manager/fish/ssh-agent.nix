{}:

{
  programs.fish.functions = {
    __ssh_agent_is_started = { 
      description = "check if ssh agent is already started";
      body = ''
        if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
          source $SSH_ENV > /dev/null
        end

        if test -z "$SSH_AGENT_PID"
          return 1
        end

        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
        #pgrep ssh-agent
        return $status
      '';
    };

    __ssh_agent_start = {
      description = "start a new ssh agent";
      body = ''
        ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
        chmod 600 $SSH_ENV
        source $SSH_ENV > /dev/null
        true  # suppress errors from setenv, i.e. set -gx
      '';
    };

    fish_ssh_agent = {
      description = "Start ssh-agent if not started yet, or uses already started ssh-agent.";
      body = ''
        if test -z "$SSH_ENV"
          set -xg SSH_ENV $HOME/.ssh/environment
        end

        if not __ssh_agent_is_started
          __ssh_agent_start
        end
      '';
    };
  };
}
