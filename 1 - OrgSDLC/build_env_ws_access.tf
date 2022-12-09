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


resource "scalr_access_policy" "ignite-env-access-policy" {
    for_each = {
        for env in local.envsec : "${env.env_name}.${env.team_name}" => env
    }
    subject {
        type = "team"
        id = each.value.team_id
    }
    scope {
        type = "environment"
        id = each.value.env_id
    }

    role_ids = toset(each.value.roles)
    
}

resource "scalr_access_policy" "ignite-workspace-access-policy" {
    for_each = {
        for wks in local.wkssec : "${wks.env_name}.${wks.wks_name}.${wks.team_name}" => wks
    }
    subject {
        type = "team"
        id = each.value.team_id
    }
    scope {
        type = "workspace"
        id = each.value.wks_id
    }
    role_ids = toset(each.value.roles)
}