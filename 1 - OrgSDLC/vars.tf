# Scalr Ignite - Quick Start Demo for Scalr
# Copyright (C) 2022 Sierra-Cedar

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Contact: devops@sierra-cedar.com

# Default Environment (Default is Environment A, which is an administrative environment, created by Scalr)
variable "env_name" {
    type    = string
    default = "Environment A"
}

variable "env_data_path" {
    default = "./environments/"
}

variable "iam_data_path" {
    default = "./iam/"
}

locals {
    envdata = yamldecode(join("\n", [ 
        for env_data in fileset(".","${var.env_data_path}/*.yaml") : file(env_data)
    ]))
    permissions = yamldecode(file("${var.iam_data_path}/permissions.yaml")) 
    teams = yamldecode(file("${var.iam_data_path}/teams.yaml"))
    roles = flatten([ 
        for each_role in yamldecode(file("${var.iam_data_path}/roles.yaml")) : {
            role_name  = each_role.name
            role_descr = each_role.description
            permissions = flatten([
                for each_perm in each_role.permissions : [
                    local.permissions[each_perm]
                ]
            ])
        }
    ])
    workspaces = flatten([ 
        for each_env in local.envdata : [
            for workspace in each_env.workspaces : {
                env_name = each_env.name
                ws_name  = workspace.name
            }
        ]
    ])
    envsec = flatten([ 
        for each_env in local.envdata : [
            for each_secmap in each_env.secmaps : {
                env_id    = scalr_environment.ignite_environments[each_env.name].id
                team_id   = scalr_iam_team.ignite_teams[each_secmap.team].id
                team_name = each_secmap.team
                env_name  = each_env.name
                roles     = flatten([
                    for each_role in each_secmap.roles : [
                        scalr_role.ignite_roles[each_role].id
                    ]
                ])
            }
        ]
    ])
    wkssec = flatten([ 
        for each_env in local.envdata : [
            for each_wks in each_env.workspaces : [
                for each_secmap in each_wks.secmaps : {
                    env_name  = each_env.name 
                    wks_name  = each_wks.name
                    wks_id    = scalr_workspace.ignite_workspaces[join(".", [each_env.name, each_wks.name])].id
                    team_name = each_secmap.team
                    team_id   = scalr_iam_team.ignite_teams[each_secmap.team].id
                    roles     = flatten([
                        for each_role in each_secmap.roles : [
                            scalr_role.ignite_roles[each_role].id
                        ]
                    ])
                }
            ]
        ]
    ])

}

variable "account_id" {
    type    = string    
    validation {
        condition     = can(regex("^acc-", var.account_id))
        error_message = "The account_id value must be a valid account id, starting with \"acc-\"."
    }
    sensitive = true

}

variable "scalr_acct_security" {
    default = [
        {
            team = "Ignite-Security-Admin-Team"
            roles = [
                "Ignite-Security-Admin-Role"
            ]
        },
        {
            team = "Ignite-CCOE-Admin-Team"
            roles = [
                "Ignite-Scalr-Integration-Admin-Role"
            ]
        }
    ]
}