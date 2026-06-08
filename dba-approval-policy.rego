package env0

default database_changed := false
default approved_by_dba := false

protected_resource := "null_resource.database"
required_team      := "DBA"

# A real change to the protected resource
database_changed {
    rc := input.plan.resource_changes[_]
    rc.address == protected_resource
    rc.change.actions[_] != "no-op"
}

# An approver from the DBA team has approved
approved_by_dba {
    team := input.approvers[_].teams[_]
    team.name == required_team
}

# Database changed, DBA has not approved yet -> hold
pending[reason] {
    database_changed
    not approved_by_dba
    reason := "Changes to the database require approval from the DBA team"
}

# Database changed and DBA approved -> proceed
allow[reason] {
    database_changed
    approved_by_dba
    reason := "Approved by DBA team"
}

# Database untouched -> no special gate
allow[reason] {
    not database_changed
    reason := "No database change, no DBA approval required"
}
