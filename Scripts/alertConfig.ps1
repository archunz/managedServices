Try
{

    Write-Output "Selecting customer subscription..."

    Get-AzureRmSubscription -TenantId b2a0bb8e-3f26-47f8-9040-209289b412a8

    Select-AzureRmSubscription -SubscriptionId 4b1a121f-fd0e-4a21-94ef-1d246437a7ca -TenantId b2a0bb8e-3f26-47f8-9040-209289b412a8
}
Catch
{
    $ErrorMessage = 'Failed to logon to Azure...'
    $ErrorMessage += "`n"
    $ErrorMessage += $_
    Write-Error -Message $ErrorMessage `
                -ErrorAction Stop
}

    Write-Output "Updating VM alert config per new commit..."

    $VMs = Get-AzureRmResource -ResourceType Microsoft.Compute/virtualMachines

Try
{  
    Foreach ($vm in $vms)
    {
        Write-Output "Deploying default alerts...."
        Write-output $vm.ResourceId

        New-AzureRmResourceGroupDeployment -Name (Get-Random) `
                                        -ResourceGroupName $vm.ResourceGroupName `
                                        -TemplateUri 'https://raw.githubusercontent.com/krnese/managedServices/master/Templates/azureClassicAlert.json' `
                                        -resourceId $vm.resourceId `
                                        -Verbose

        Write-Output "Done!"                                       
    }
}
Catch
{
    $ErrorMessage = 'Unable to update alert on VM:'
    $ErrorMessage += "`n"
    $ErrorMessage += $vm.Name
    $ErrorMessage += $_
    Write-Error -Message $ErrorMessage `
                -ErrorAction Stop
}

Write-Output "Job completed"
