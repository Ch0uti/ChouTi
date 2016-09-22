1. In `PATH`, create a file called `git-jira`. Make is executable with `chmod +x git-jira`
2. In the file, paste following bash code
  ```bash
  #!/bin/bash
  
  set -eu
  
  DEFAULT_PAGE="https://jira.thescore.com/secure/RapidBoard.jspa?rapidView=76"
  
  jira_ticket_id="$(git rev-parse --abbrev-ref HEAD | egrep -o '[A-Z]+-[0-9]+' || true)"
  
  if [[ ! -z "$jira_ticket_id" ]]; then
      open "https://jira.thescore.com/browse/$jira_ticket_id"
  else
      open "$DEFAULT_PAGE"
  fi
  
  ```

3. Restart the terminal, type `git jira`

References:
> [Custom Git Commands in 3 Steps](http://thediscoblog.com/blog/2014/03/29/custom-git-commands-in-3-steps/)
