{ cfg, pkgs }:
let
  cacheCmd = agents: {
    inherit agents;
    label = "Yay!";
    command = ''
      nix build
    '';
  };
in
  with cfg; {

    steps = {

      commands.cache-mac = cacheCmd { queue = "mac"; };
      commands.cache-linux = cacheCmd { queue = "linux"; };

      commands.docker.command = ''
        docker build -t docker/image:tag .
        docker push docker/image:tag
      '';

      commands.deploy-development = {
        dependsOn = [ "docker" ];
        command = ''
          do this
          do that
        '';
      };

      triggers.gitops = {
        trigger = "gitops";
        dependsOn = [ "deploy-development" "block" ];
      };

      inputs.block.input = "Continue with deployment?";
      inputs.block.fields = {
        textInput.thingie.text = "hello";
        textInput.thingie.hint = "The name for the release";
      };

    };

  }