#!/usr/bin/env bash
echo "Installing az from Public Gallery as '$(whoami)'" \
&& pwsh -command Install-Module -Name Az.Accounts -RequiredVersion 2.2.1 -Scope AllUsers -Force 
# && pwsh -command Install-Module -Name Az.Resources -RequiredVersion 4.3.1 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name SqlServer -RequiredVersion 21.1.18230 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.DataFactory -RequiredVersion 1.11.0 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Sql -RequiredVersion 1.4.0 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Automation -RequiredVersion 1.4.0 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Compute -RequiredVersion 4.5.0 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Storage -RequiredVersion 3.2.1 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Network -RequiredVersion 3.0.0 -Scope AllUsers -Force \
# && pwsh -command Install-Module -Name Az.Security -RequiredVersion 0.11.0 -Scope AllUsers -Force 