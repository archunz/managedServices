

    Write-Output "Authenticating to Azure subs using SPN..."

    $sub = Get-AzureRmSubscription -TenantId b2a0bb8e-3f26-47f8-9040-209289b412a8

    foreach($s in $sub)
    {
        if($s.Id -ne "0a938bc2-0bb8-4688-bd37-9964427fe0b0")
        {
         Write-Output "Iterating through customer subscriptions..."
Try
{
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

        $VMs = Get-AzureRmVm

        Write-Output "Fetched all VMs..."

Try
{  
    Foreach ($vm in $vms)
    {
        Write-Output "Deploying default alerts...."
        Write-output $vm.id

        New-AzureRmResourceGroupDeployment -Name mspAlert `
                                        -ResourceGroupName $vm.ResourceGroupName `
                                        -TemplateUri 'https://raw.githubusercontent.com/krnese/managedServices/master/Templates/azureClassicAlert.json' `
                                        -resourceId $vm.id `
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
  
  }
}