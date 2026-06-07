package env0

import future.keywords.in
import future.keywords.if

protected_resource := "null_resource.database"
required_team      := "DBA"

# True if the plan changes the protected resource
database_changed if {
    some rc in input.plan.resource_changes
    rc.address == protected_resource
    some action in rc.change.actions
    action != "no-op"
}

# True if an approver belongs to the DBA team
approved_by_dba if {
    some approver in input.approvers
    some team in approver.teams
    team.name == required_team
}

# Database changed, DBA has not approved yet -> hold
pending["Changes to the database require approval from the DBA team"] if {
    database_changed
    not approved_by_dba
}

# Database changed and DBA approved -> proceed
allow if {
    database_changed
    approved_by_dba
}

# Database untouched -> no special gate
allow if {
    not database_changed
}
