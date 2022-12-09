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

resource "scalr_iam_team" "ignite_teams" {
    for_each = {
        for team in local.teams : "${team.name}" => team 
    }
    name        = each.value.name
    description = each.value.description
    account_id  = var.account_id
    lifecycle {
        ignore_changes = [
            users
        ]
    }
}
