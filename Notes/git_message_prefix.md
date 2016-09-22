```bash
#!/bin/sh

jira_ticket_id="$(git rev-parse --abbrev-ref HEAD | egrep -o '[A-Z]+-[0-9]+' || true)"

if [[ ! -z "$jira_ticket_id" ]]; then
    sed -i.old "1s;^;$jira_ticket_id: ;" "$1"
fi

```

put in `.git/hooks/prepare-commit-msg` & make executable
