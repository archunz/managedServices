Write-Output "Selecting customer subscription..."

Write-output "who am i?"
get-azurermcontext

Get-AzureRmSubscription -TenantId b2a0bb8e-3f26-47f8-9040-209289b412a8

Select-AzureRmSubscription -SubscriptionId 4b1a121f-fd0e-4a21-94ef-1d246437a7ca -TenantId b2a0bb8e-3f26-47f8-9040-209289b412a8

Write-Output "Updating VM alert config per new commit..."

$VMs = Get-AzureRmVm

Foreach ($vm in $vms)
{
    Write-Output "Deploying default alerts...."

    New-AzureRmResourceGroupDeployment -Name "vmAlert" `
                                       -ResourceGroupName $vm.ResourceGroupName `
                                       -TemplateUri 'https://raw.githubusercontent.com/krnese/managedServices/master/Templates/azureClassicAlert.json' `
                                       -resourceId $vm.id `
                                       -Verbose

    Write-Output "Done!"                                       
}