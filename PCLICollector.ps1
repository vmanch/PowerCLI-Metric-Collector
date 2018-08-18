#Powershell collector scripts for vCenter Inventory, Relationships, Performance and Capacity data
#v1.0 vMan.ch, 01.06.2016 - Initial Version
<#

    .SYNOPSIS
        Created to collect stuff from Virtual Center or vRops

        Usage:

        -----------------------------------------------
        Performance Metric Collection
        -----------------------------------------------

        VM Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCE'
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        HOST Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCE'	
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        DATASTORE Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'DATASTORE' -CollectionType 'PERFORMANCE'	
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'DATASTORE' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        CLUSTER Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCE'
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'



        -----------------------------------------------
        Performance Real Time Collection - Collects Last hour of data from script execution.
        -----------------------------------------------
            Must be run within the hour otherwise the data will be rolled up and the array of objects to collect must go in the file Elementlist_'MetricSource'.csv
        
        VM Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCERT'

        HOST Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCERT'	

        CLUSTER Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCERT'


        -----------------------------------------------
        Performance Metric Collection from vROPS
        -----------------------------------------------

        VM Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'VM-OM' -CollectionType 'PERFORMANCEOM'
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'VM-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        HOST Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'HOST-OM' -CollectionType 'PERFORMANCEOM'	
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'HOST-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        DATASTORE Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'DATASTORE-OM' -CollectionType 'PERFORMANCEOM'	
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'DATASTORE-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        CLUSTER Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'CLUSTER-OM' -CollectionType 'PERFORMANCEOM'
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'CLUSTER-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        S3 Estimate run - All VM's Daily 30min


        -----------------------------------------------
        Inventory Collection
        -----------------------------------------------

        #Count of VM's per Datastore.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType DSVMCOUNT


        #Count of VM's per Host.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMHOSTCOUNT


        #Count of VM's per Cluster.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMCLUCOUNT


        #Sum of vCPU's USED per Host.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VCPUHOSTSUM


        #Sum of vCPU's USED per Cluster.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VCPUCLUSUM


        #Sum of vCPU's USED per VMVCPUS.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMVCPUS


        #Sum of vCPU's USED per VMVMEM.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMVMEM


        #Sum of vCPU's USED per HOSTMEM.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTMEM


        #Sum of vCPU's USED per HOSTCPUCORES.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTCPUCORES



        -----------------------------------------------
        Relationship Collection
        -----------------------------------------------

        #VM to Datastore(s)

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMDSRELATION


        #VM to Cluster

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMCLURELATION


        #VM to HOST

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMHOSTRELATION


        #HOST to Datastore(s)

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTDSRELATION


        #HOST to Cluster

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTCLURELATION


        #Cluster to Datacenter

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType CLUDCRELATION

#>

param
(
    [String]$Server,
    [String]$MetricSource,
    [String]$CollectionType,
    [String]$User,
    [String]$Password,
    [DateTime]$StartDate = (Get-date).adddays(-1),
    [DateTime]$EndDate = (Get-date)
)

#Variables

[xml]$Config = Get-Content 'D:\Powershell\PCLICollector\MetricConfig.xml'
$uploadFolderPath =  $Config.VMDatacollector.UploadSettings.LocalSettings | select RawFileFolder,INVFileFolder,RELFileFolder,RTFileFolder,ArchiveFolder,LogFolder

$Invoke = $Config.VMDataCollector.PerfConfigs.$MetricSource.ObjectType
$Interval = $Config.VMDataCollector.PerfConfigs.$MetricSource.Interval

$MetricXPath = '/VMDataCollector/PerfConfigs/' +$MetricSource+ '/Config'

#Jobs
$maxJobCount = $Config.VMDatacollector.Jobs.MaxJobCount
$sleepTimer = $Config.VMDatacollector.Jobs.SleepTimerSec

##################
### FUNCTIONS
##################

# Logs

Function Log([String]$message, [String]$LogType, [String]$LogFile){
    $date = Get-Date -UFormat '%m-%d-%Y %H:%M:%S'
    $message = $date + "`t" + $LogType + "`t" + $message
    $message >> $LogFile
}

#Below function borrowed from http://www.lucd.info/2011/06/19/datastore-usage-statistics/


function Get-Stat2 {
<#
.SYNOPSIS  Retrieve vSphere statistics
.DESCRIPTION The function is an alternative to the Get-Stat cmdlet.
  It's primary use is to provide functionality that is missing
  from the Get-Stat cmdlet.
.NOTES  Author:  Luc Dekens
.PARAMETER Entity
  Specify the VIObject for which you want to retrieve statistics
  This needs to be an SDK object
.PARAMETER Start
  Start of the interval for which to retrive statistics
.PARAMETER Finish
  End of the interval for which to retrive statistics
.PARAMETER Stat
  The identifiers of the metrics to retrieve
.PARAMETER Instance
  The instance property of the statistics to retrieve
.PARAMETER Interval
  Specify for which interval you want to retrieve statistics.
  Allowed values are RT, HI1, HI2, HI3 and HI4
.PARAMETER MaxSamples
  The maximum number of samples for each metric
.PARAMETER QueryMetrics
  Switch to indicate that the function should return the available
  metrics for the Entity specified
.PARAMETER QueryInstances
  Switch to indicate that the function should return the valid instances
  for a specific Entity and Stat
.EXAMPLE
  PS> Get-Stat2 -Entity $vm.Extensiondata -Stat "cpu.usage.average" -Interval "RT"
#>
 
  [CmdletBinding()]
  param (
  [parameter(Mandatory = $true,  ValueFromPipeline = $true)]
  [PSObject]$Entity,
  [DateTime]$Start,
  [DateTime]$Finish,
  [String[]]$Stat,
  [String]$Instance = "",
  [ValidateSet("RT","HI1","HI2","HI3","HI4")]
  [String]$Interval = "RT",
  [int]$MaxSamples,
  [switch]$QueryMetrics,
  [switch]$QueryInstances)
 
  # Test if entity is valid
  $EntityType = $Entity.GetType().Name
 
  if(!(("HostSystem",
        "VirtualMachine",
        "ClusterComputeResource",
        "Datastore",
        "ResourcePool") -contains $EntityType)) {
    Throw "-Entity parameters should be of type HostSystem, VirtualMachine, ClusterComputeResource, Datastore or ResourcePool"
  }
 
  $perfMgr = Get-View (Get-View ServiceInstance).content.perfManager
 
  # Create performance counter hashtable
  $pcTable = New-Object Hashtable
  $keyTable = New-Object Hashtable
  foreach($pC in $perfMgr.PerfCounter){
    if($pC.Level -ne 99){
      if(!$pctable.containskey($pC.GroupInfo.Key + "." + $pC.NameInfo.Key + "." + $pC.RollupType)){
        $pctable.Add(($pC.GroupInfo.Key + "." + $pC.NameInfo.Key + "." + $pC.RollupType),$pC.Key)
        $keyTable.Add($pC.Key, $pC)
      }
    }
  }
 
  # Test for a valid $Interval
  if($Interval.ToString().Split(" ").count -gt 1){
    Throw "Only 1 interval allowed."
  }
 
  $intervalTab = @{"RT"=$null;"HI1"=0;"HI2"=1;"HI3"=2;"HI4"=3}
  $dsValidIntervals = "HI2","HI3","HI4"
  $intervalIndex = $intervalTab[$Interval]
 
  if($EntityType -ne "datastore"){
    if($Interval -eq "RT"){
      $numinterval = 20
    }
    else{
      $numinterval = $perfMgr.HistoricalInterval[$intervalIndex].SamplingPeriod
    }
  }
  else{
    if($dsValidIntervals -contains $Interval){
      $numinterval = $null
      if(!$Start){
        $Start = (Get-Date).AddSeconds($perfMgr.HistoricalInterval[$intervalIndex].SamplingPeriod - $perfMgr.HistoricalInterval[$intervalIndex].Length)
      }
      if(!$Finish){
        $Finish = Get-Date
      }
    }
    else{
      Throw "-Interval parameter $Interval is invalid for datastore metrics."
    }
  }
 
  # Test if QueryMetrics is given
  if($QueryMetrics){
    $metrics = $perfMgr.QueryAvailablePerfMetric($Entity.MoRef,$null,$null,$numinterval)
    $metricslist = @()
    foreach($pmId in $metrics){
      $pC = $keyTable[$pmId.CounterId]
      $metricslist += New-Object PSObject -Property @{
        Group = $pC.GroupInfo.Key
        Name = $pC.NameInfo.Key
        Rollup = $pC.RollupType
        Id = $pC.Key
        Level = $pC.Level
        Type = $pC.StatsType
        Unit = $pC.UnitInfo.Key
      }
    }
    return ($metricslist | Sort-Object -unique -property Group,Name,Rollup)
  }
 
  # Test if start is valid
  if($Start -ne $null -and $Start -ne ""){
    if($Start.gettype().name -ne "DateTime") {
      Throw "-Start parameter should be a DateTime value"
    }
  }
 
  # Test if finish is valid
  if($Finish -ne $null -and $Finish -ne ""){
    if($Finish.gettype().name -ne "DateTime") {
      Throw "-Start parameter should be a DateTime value"
    }
  }
 
  # Test start-finish interval
  if($Start -ne $null -and $Finish -ne $null -and $Start -ge $Finish){
    Throw "-Start time should be 'older' than -Finish time."
  }
 
  # Test if stat is valid
  $unitarray = @()
  $InstancesList = @()
 
  foreach($st in $Stat){
    if($pcTable[$st] -eq $null){
      Throw "-Stat parameter $st is invalid."
    }
    $pcInfo = $perfMgr.QueryPerfCounter($pcTable[$st])
    $unitarray += $pcInfo[0].UnitInfo.Key
    $metricId = $perfMgr.QueryAvailablePerfMetric($Entity.MoRef,$null,$null,$numinterval)
 
    # Test if QueryInstances in given
    if($QueryInstances){
      $mKey = $pcTable[$st]
      foreach($metric in $metricId){
        if($metric.CounterId -eq $mKey){
          $InstancesList += New-Object PSObject -Property @{
            Stat = $st
            Instance = $metric.Instance
          }
        }
      }
    }
    else{
      # Test if instance is valid
      $found = $false
      $validInstances = @()
      foreach($metric in $metricId){
        if($metric.CounterId -eq $pcTable[$st]){
          if($metric.Instance -eq "") {$cInstance = '""'} else {$cInstance = $metric.Instance}
          $validInstances += $cInstance
          if($Instance -eq $metric.Instance){$found = $true}
        }
      }
      if(!$found){
        Throw "-Instance parameter invalid for requested stat: $st.`nValid values are: $validInstances"
      }
    }
  }
  if($QueryInstances){
    return $InstancesList
  }
 
  $PQSpec = New-Object VMware.Vim.PerfQuerySpec
  $PQSpec.entity = $Entity.MoRef
  $PQSpec.Format = "normal"
  $PQSpec.IntervalId = $numinterval
  $PQSpec.MetricId = @()
  foreach($st in $Stat){
    $PMId = New-Object VMware.Vim.PerfMetricId
    $PMId.counterId = $pcTable[$st]
    if($Instance -ne $null){
      $PMId.instance = $Instance
    }
    $PQSpec.MetricId += $PMId
  }
  $PQSpec.StartTime = $Start
  $PQSpec.EndTime = $Finish
  if($MaxSamples -eq 0 -or $numinterval -eq 20){
    $PQSpec.maxSample = $null
  }
  else{
    $PQSpec.MaxSample = $MaxSamples
  }
  $Stats = $perfMgr.QueryPerf($PQSpec)
 
  # No data available
  if($Stats[0].Value -eq $null) {return $null}
 
  # Extract data to custom object and return as array
  $data = @()
  for($i = 0; $i -lt $Stats[0].SampleInfo.Count; $i ++ ){
    for($j = 0; $j -lt $Stat.Count; $j ++ ){
      $data += New-Object PSObject -Property @{
        CounterId = $Stats[0].Value[$j].Id.CounterId
        CounterName = $Stat[$j]
        Instance = $Stats[0].Value[$j].Id.Instance
        Timestamp = $Stats[0].SampleInfo[$i].Timestamp
        Interval = $Stats[0].SampleInfo[$i].Interval
        Value = $Stats[0].Value[$j].Value[$i]
        Unit = $unitarray[$j]
        Entity = $Entity.Name
        EntityId = $Entity.MoRef.ToString()
      }
    }
  }
  if($MaxSamples -eq 0){
    $data | Sort-Object -Property Timestamp -Descending
  }
  else{
    $data | Sort-Object -Property Timestamp -Descending | select -First $MaxSamples
  }
}

#Load Snapins for VMWare

function LoadSnapins(){
    $snapinList = @( "VMware.VimAutomation.Core",“VMware.VimAutomation.vROps”)

    $loaded = Get-PSSnapin -Name $snapinList -ErrorAction SilentlyContinue | % {$_.Name}
    $registered = Get-PSSnapin -Name $snapinList -Registered -ErrorAction SilentlyContinue | % {$_.Name}
    $notLoaded = $registered | ? {$loaded -notcontains $_}

    foreach ($snapin in $registered) {
        if ($loaded -notcontains $snapin) {
        Add-PSSnapin $snapin
        }
    }
}

# Connect to VC

Function ConnectVC($FunkVC, $FunkLogFileLoc){
    Log -Message "Connecting to VC: $FunkVC" -LogType "INFO" -LogFile $FunkLogFileLoc
    $Funkconnstat = Connect-VIServer -server $FunkVC
        if ($Funkconnstat){
            Log -Message "Connection succeeded to VC: $FunkVC" -LogType "INFO" -LogFile $FunkLogFileLoc
            Write-Host "Connection succeeded to VC: $FunkVC"
        }
        else{
            Log -Message "Failed to connect to VC: $FunkVC" -LogType "ERROR" -LogFile $FunkLogFileLoc
            Write-Host "Failed to connect to VC: $FunkVC"
        }
}

# Connect to OM Server

Function ConnectOM($FunkOM, $FunkLogFileLoc){
    Log -Message "Connecting to VC: $FunkOM" -LogType "INFO" -LogFile $FunkLogFileLoc
    $Funkconnstat = Connect-OMServer -server $FunkOM
        if ($Funkconnstat){
            Log -Message "Connection succeeded to Operations Manager: $FunkOM" -LogType "INFO" -LogFile $FunkLogFileLoc
            Write-Host "Connection succeeded to Operations Manager: $FunkOM"
        }
        else{
            Log -Message "Failed to connect to Operations Manager: $FunkOM" -LogType "ERROR" -LogFile $FunkLogFileLoc
            Write-Host "Failed to connect to Operations Manager: $FunkOM"
        }
}

#Disconnect from VC

Function DisconnectVC($FunkDCVC, $FunkDCLogFileLoc){
    Log -Message "Disconnecting from VC: $FunkDCVC" -LogType "INFO" -LogFile $FunkDCLogFileLoc
    $DCFunkconnstat = Disconnect-VIServer -server $FunkDCVC -Confirm $false
        if ($DCFunkconnstat){
            Log -Message "Connection to VC: $FunkDCVC Dropped" -LogType "INFO" -LogFile $FunkDCLogFileLoc
            Write-Host "Connection to VC: $FunkDCVC Dropped"
        }
        else{
            Log -Message "Failed to disconnect from to VC: $FunkDCVC GOD HELP US ALL!" -LogType "ERROR" -LogFile $FunkDCLogFileLoc
            Write-Host "Failed to disconnect from to VC: $FunkDCVC GOD HELP US ALL!"
        }
}

#Disconnect from OM

Function DisconnectOM($FunkDCOM, $FunkDCLogFileLoc){
    Log -Message "Disconnecting from OM: $FunkDCOM" -LogType "INFO" -LogFile $FunkDCLogFileLoc
    $DCFunkconnstat = Disconnect-OMServer -server $FunkDCOM -Force:$false -confirm:$false
        if ($DCFunkconnstat){
            Log -Message "Connection to OM: $FunkDCOM Dropped" -LogType "INFO" -LogFile $FunkDCLogFileLoc
            Write-Host "Connection to OM: $FunkDCOM Dropped"
        }
        else{
            Log -Message "Failed to disconnect from to OM: $FunkDCOM GOD HELP US ALL!" -LogType "ERROR" -LogFile $FunkDCLogFileLoc
            Write-Host "Failed to disconnect from to OM: $FunkDCOM GOD HELP US ALL!"
        }
}

#PerformanceList Script Block.

$scriptBlock = {
param
(
    [String]$Element,
    [String]$HOSTNAME,
    [String]$Server,
    [String]$MetricSource,
    [DateTime]$start,
    [DateTime]$finish,
    [XML]$CFG
    
)


$uploadFolderPath =  $CFG.VMDatacollector.UploadSettings.LocalSettings | select RawFileFolder,RTFileFolder,LogFolder
$MetricXPath = '/VMDataCollector/PerfConfigs/' +$MetricSource+ '/Config'

        Add-PSSnapin VMware.VimAutomation.Core
         Connect-VIServer -server $Server
         foreach ($node in @($CFG | Select-Xml -XPath $MetricXPath))
            {
            #Collection Date, not run time
            $MetricName += @($node.Node.MetricName)
            }
            $StartDateFile = $Start.tostring("yyyyMMdd-hhmmss")            
            $EndDateFile = $Finish.tostring("yyyyMMdd-hhmmss")
            $outputfile = $uploadFolderPath.RTFileFolder+$HOSTNAME+'_'+$MetricSource+'_'+$StartDateFile+'_'+$EndDateFile+'.csv'
            $Stats = New-Object Hashtable
            $Stats = Get-stat -entity $element -start $start -finish $finish -stat $MetricName -realtime |`
            Select Entity,Timestamp,MetricId,Unit,Instance,Value | Export-Csv $outputfile -NoTypeInformation -UseCulture
            Disconnect-VIServer -server $Server -Confirm $false

}

#-------------Boom Start Script-------------#

Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Loading PowerCLI Snapins'

LoadSnapins

Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Run baby run!'

switch($CollectionType)
    {

#########################
# Metric Collection
#########################

PERFORMANCE {

    if ($MetricSource -eq "DATASTORE" ){

        $VCLog = $uploadFolderPath.LogFolder+$CollectionType+'_'+'VCCONNECTIONS.log'
         ConnectVC -FunkVC $Server -FunkLogFileLoc $VCLog
         Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Running Datastore Metric Collection'
         Write-host $MetricXPat
         foreach ($node in @($Config | Select-Xml -XPath $MetricXPath))
            {
            #Collection Date, not run time
            $MetricName += @($node.Node.MetricName)
            }
            $ds = Get-Datastore
            $StartDateFile = $StartDate.tostring("yyyyMMdd")            
            $EndDateFile = $EndDate.tostring("yyyyMMdd")
            $OutputFile = $uploadFolderPath.RawFileFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDateFile+'_'+$Server+'.csv'
            $LogFileLoc = $uploadFolderPath.LogFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDateFile+'_'+$Server+'.log'
            Log -Message "Start Data collection for Datastores" -LogType "INFO" -LogFile $LogFileLoc
            Foreach ($Datastore in $ds) {
                $DatastoreDATA = (Get-Datastore $Datastore).Extensiondata
                $report += Get-Stat2 -entity $DatastoreDATA -stat $MetricName -interval $Interval -start $StartDate -finish $EndDate
                 }
            $report | Select Entity,Timestamp,CounterName,Unit,Instance,Value | Export-Csv $OutputFile -NoTypeInformation -UseCulture
            Log -Message "Finished Data collection for Datastores" -LogType "INFO" -LogFile $LogFileLoc
        DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VCLog
      }

  else {

        $VCLog = $uploadFolderPath.LogFolder+$CollectionType+'_'+'VCCONNECTIONS.log'
         ConnectVC -FunkVC $Server -FunkLogFileLoc $VCLog
         $ColObjs = & $Invoke
         Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Running' $MetricSource 'Metric Collection'
         foreach ($node in @($Config | Select-Xml -XPath $MetricXPath))
            {
            #Collection Date, not run time
            $MetricName += @($node.Node.MetricName)
            }
            $StartDateFile = $StartDate.tostring("yyyyMMdd")            
            $EndDateFile = $EndDate.tostring("yyyyMMdd")
            $OutputFile = $uploadFolderPath.RawFileFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDateFile+'_'+$Server+'.csv'
            $LogFileLoc = $uploadFolderPath.LogFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDaverile+'_'+$Server+'.log'
            Log -Message "Start Data collection for $MetricSource" -LogType "INFO" -LogFile $LogFileLoc
            $Stats = New-Object Hashtable
            $Stats = Get-stat -entity $ColObjs -start $StartDate.ToString("yyyy/MM/dd") -finish $EndDate.ToString("yyyy/MM/dd") -stat $MetricName -intervalsec $Interval |`
            Select Entity,Timestamp,MetricId,Unit,Instance,Value | Export-Csv $OutputFile -NoTypeInformation -UseCulture
            Log -Message "Finished Data collection for $MetricName / $MetricLabel" -LogType "INFO" -LogFile $LogFileLoc
        DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VCLog

  }

}

PERFORMANCERT {


        $ElementListPath = $Config.VMDatacollector.Jobs.ElementList
        $ElementListPath = $ElementListPath+'Elementlist_'+$MetricSource+'.csv'
        $Elements = import-csv $ElementListPath
        
        
        $jobQueue = New-Object System.Collections.ArrayList
        
        $finish = Get-Date
        $start = $finish.AddHours(-1)

        # Create our job queue.


            # Main loop of the script.  
            # Loop through each VM and start a new job if we have less than $maxJobCount outstanding jobs.  
            # If the $maxJobCount has been reached, sleep 3 seconds and check again.  
            foreach ($Element in $Elements) {
              # Wait until job queue has a slot available.
              while ($jobQueue.count -ge $maxJobCount) {
                echo "jobQueue count is $($jobQueue.count): Waiting for jobs to finish before adding more."
                foreach ($jobObject in $jobQueue.toArray()) {
            	    if ($jobObject.job.state -eq 'Completed') { 
            	      echo "jobQueue count is $($jobQueue.count): Removing job: $($jobObject.element.HOSTNAME)"
            	      $jobQueue.remove($jobObject) 		
            	    }
            	  }
            	sleep $sleepTimer
              }  
  
              echo "jobQueue count is $($jobQueue.count): Adding new job: $($element.HOSTNAME)"
              
            $HOSTNAME = $Element.HOSTNAME
              
               $job = Start-Job -name $Element.HOSTNAME -ScriptBlock $scriptBlock -ArgumentList $Element.HOSTNAME, $HOSTNAME, $Server, $MetricSource, $start, $finish, $Config                    

              $jobObject          = "" | select Element, job
              $jobObject.Element  = $Element
              $jobObject.job      = $job
              $jobQueue.add($jobObject) | Out-Null
            }

Get-Job | Wait-Job | Out-Null


}

PERFORMANCEOM {

        Import-Module VMware.VimAutomation.vROps
        $OMLog = $uploadFolderPath.LogFolder+$CollectionType+'_'+'OMCONNECTIONS.log'
         ConnectOM -FunkOM $Server -FunkLogFileLoc $OMLog
         $ColObjs = Get-OMResource | where-object {$_.ResourceKind -eq $Invoke}
         Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Running' $MetricSource 'Metric Collection'
         foreach ($node in @($Config | Select-Xml -XPath $MetricXPath))
            {
            #Collection Date, not run time
            $MetricName = $node.Node.MetricName
            $RollupType = $node.Node.Rollup
            $IntervalCount = $node.Node.IntervalCount
            $StartDateFile = $StartDate.tostring("yyyyMMdd-hhmmss")            
            $EndDateFile = $EndDate.tostring("yyyyMMdd-hhmmss")
            $OutputFile = $uploadFolderPath.RawFileFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDateFile+'_'+$Server+'.csv'
            $LogFileLoc = $uploadFolderPath.LogFolder+$MetricSource+'_'+$Interval+'_'+$StartDateFile+'_'+$EndDateFile+'_'+$Server+'.log'
            Log -Message "Start $MetricName collection for $MetricSource" -LogType "INFO" -LogFile $LogFileLoc
            $Stats = New-Object Hashtable
            $Stats = Get-OMStat -Resource $ColObjs -Key $MetricName -IntervalType $Interval -IntervalCount 1 -RollupType "AVG" -From $StartDate.ToString("yyyy/MM/dd hh:mm:ss") -To $EndDate.ToString("yyyy/MM/dd hh:mm:ss") |`
            Select Value, Resource, Time, Key, RollupType | Export-Csv $OutputFile -NoTypeInformation -UseCulture
            Log -Message "Finished Data collection for $MetricName / $MetricLabel" -LogType "INFO" -LogFile $LogFileLoc
            }
        DisconnectOM -FunkDCOM $Server -FunkDCLogFileLoc $OMLog


}

DSVMCOUNT { 
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $DSVMCOUNTDate = Get-Date
            $DSVMCOUNTDate = $DSVMCOUNTDate.ToString("yyyyMMdd")
            $DSVMCOUNTFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$DSVMCOUNTDate+'_'+$Server+'.csv'
            $DSVMCOUNTLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$DSVMCOUNTDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $DSVMCOUNTLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $DSVMCOUNTLogFileLoc
            Get-Datastore | Select Name, `
            @{N="NumVM";E={($_ | Get-VM).Count}} | `
            Export-Csv -path $DSVMCOUNTFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $DSVMCOUNTLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $DSVMCOUNTLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VMHOSTCOUNT {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VMHOSTCOUNTDate = Get-Date
            $VMHOSTCOUNTDate = $VMHOSTCOUNTDate.ToString("yyyyMMdd")
            $VMHOSTCOUNTFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VMHOSTCOUNTDate+'_'+$Server+'.csv'
            $VMHOSTCOUNTLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMHOSTCOUNTDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMHOSTCOUNTLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMHOSTCOUNTLogFileLoc
            Get-VMHost | Select Name, `
            @{N="NumVM";E={($_ | Get-VM).Count}} | `
            Export-Csv -path $VMHOSTCOUNTFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMHOSTCOUNTLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMHOSTCOUNTLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VMCLUCOUNT {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VMCLUCOUNTDate = Get-Date
            $VMCLUCOUNTDate = $VMCLUCOUNTDate.ToString("yyyyMMdd")
            $VMCLUCOUNTFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VMCLUCOUNTDate+'_'+$Server+'.csv'
            $VMCLUCOUNTLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMCLUCOUNTDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMCLUCOUNTLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMCLUCOUNTLogFileLoc
            Get-Cluster | Select Name, `
            @{N="NumVM";E={($_ | Get-VM).Count}} | `
            Export-Csv -path $VMCLUCOUNTFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMCLUCOUNTLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMCLUCOUNTLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VCPUHOSTSUM  {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VCPUHOSTSUMDate = Get-Date
            $VCPUHOSTSUMDate = $VCPUHOSTSUMDate.ToString("yyyyMMdd")
            $VCPUHOSTSUMFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VCPUHOSTSUMDate+'_'+$Server+'.csv'
            $VCPUHOSTSUMLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VCPUHOSTSUMDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VCPUHOSTSUMLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VCPUHOSTSUMLogFileLoc
            $(foreach ($vmhost in get-vmhost){ $vms=$vmhost|get-vm; $vmsVcpucount=($vms|Measure-Object -Property numcpu -Sum).sum; "" `
            | Select @{N='Host';E={$vmhost.name}},
            @{N='vCPUs';E={$vmsVcpucount}}}) | `
            Export-Csv -path $VCPUHOSTSUMFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VCPUHOSTSUMLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VCPUHOSTSUMLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VCPUCLUSUM  {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VCPUCLUSUMDate = Get-Date
            $VCPUCLUSUMDate = $VCPUCLUSUMDate.ToString("yyyyMMdd")
            $VCPUCLUSUMFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VCPUCLUSUMDate+'_'+$Server+'.csv'
            $VCPUCLUSUMLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VCPUCLUSUMDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VCPUCLUSUMLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VCPUCLUSUMLogFileLoc
            Get-Cluster |
            Select-Object -Property Name,
            @{Name="vCPUs";E={$_ | Get-VM | Measure-Object -Property NumCpu -Sum | Select-Object -ExpandProperty Sum }} `
            | Export-Csv -path $VCPUCLUSUMFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VCPUCLUSUMLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VCPUCLUSUMLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VMVCPUS {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VMVCPUSDate = Get-Date
            $VMVCPUSDate = $VMVCPUSDate.ToString("yyyyMMdd")
            $VMVCPUSFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VMVCPUSDate+'_'+$Server+'.csv'
            $VMVCPUSLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMVCPUSDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMVCPUSLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMVCPUSLogFileLoc
            Get-VM | select Name, NumCPU | Export-Csv -path $VMVCPUSFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMVCPUSLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMVCPUSLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VMVMEM {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $VMVMEMDate = Get-Date
            $VMVMEMDate = $VMVMEMDate.ToString("yyyyMMdd")
            $VMVMEMFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$VMVMEMDate+'_'+$Server+'.csv'
            $VMVMEMLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMVMEMDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMVMEMLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMVMEMLogFileLoc
            Get-VM | select Name, MemoryGB| Export-Csv -path $VMVMEMFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $VMVMEMLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMVMEMLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

HOSTMEM {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $HOSTMEMDate = Get-Date
            $HOSTMEMDate = $HOSTMEMDate.ToString("yyyyMMdd")
            $HOSTMEMFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$HOSTMEMDate+'_'+$Server+'.csv'
            $HOSTMEMLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$HOSTMEMDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $HOSTMEMLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $HOSTMEMLogFileLoc
            Get-VMhost | select Name, MemoryTotalGB | Export-Csv -path $HOSTMEMFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $HOSTMEMLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $HOSTMEMLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

HOSTCPUCORES {
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Inventory Data'
            $HOSTCPUCORESDate = Get-Date
            $HOSTCPUCORESDate = $HOSTCPUCORESDate.ToString("yyyyMMdd")
            $HOSTCPUCORESFile = $uploadFolderPath.INVFileFolder+$CollectionType+'_'+$HOSTCPUCORESDate+'_'+$Server+'.csv'
            $HOSTCPUCORESLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$HOSTCPUCORESDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $HOSTCPUCORESLogFileLoc
            Log -Message "Starting Inventory collection for $CollectionType" -LogType "INFO" -LogFile $HOSTCPUCORESLogFileLoc
            Get-VMhost | select Name, NumCpu | Export-Csv -path $HOSTCPUCORESFile -NoTypeInformation
            Log -Message "Finished Inventory collection for $CollectionType" -LogType "INFO" -LogFile $HOSTCPUCORESLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $HOSTCPUCORESLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Inventory Data'
            }

VMDSRELATION { 
            
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $VMDSRelDate = Get-Date
            $VMDSRelDate = $VMDSRelDate.ToString("yyyyMMdd")
            $VMDSRelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$VMDSRelDate+'_'+$Server+'.csv'
            $VMDSLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMDSRelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMDSLogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMDSLogFileLoc
            Get-VM | Select Name, `
            @{N="Datatore";E={Get-Datastore -VM $_}} | `
            Export-Csv -path $VMDSRelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMDSLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMDSLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

VMCLURELATION {

            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $VMCLURelDate = Get-Date
            $VMCLURelDate = $VMCLURelDate.ToString("yyyyMMdd")
            $VMCLURelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$VMCLURelDate+'_'+$Server+'.csv'
            $VMCLULogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMCLURelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMCLULogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMCLULogFileLoc
            Get-VM | Select Name, `
            @{N="Cluster";E={Get-Cluster -VM $_}} | `
            Export-Csv -path $VMCLURelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMCLULogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMCLULogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

VMHOSTRELATION {

            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $VMHOSTRelDate = Get-Date
            $VMHOSTRelDate = $VMHOSTRelDate.ToString("yyyyMMdd")
            $VMHOSTRelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$VMHOSTRelDate+'_'+$Server+'.csv'
            $VMHOSTLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$VMHOSTRelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $VMHOSTLogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMHOSTLogFileLoc
            Get-VM | Select Name, `
            @{N="ESXHost";E={Get-VMHost -VM $_}} | `
            Export-Csv -path $VMHOSTRelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $VMHOSTLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $VMHOSTLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

HOSTDSRELATION {

            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $HOSTDSRelDate = Get-Date
            $HOSTDSRelDate = $HOSTDSRelDate.ToString("yyyyMMdd")
            $HOSTDSRelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$HOSTDSRelDate+'_'+$Server+'.csv'
            $HOSTDSLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$HOSTDSRelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $HOSTDSLogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $HOSTDSLogFileLoc
            Get-VMHost | Select Name, `
            @{N="Datastore";E={Get-Datastore -HOST $_}} | `
            Export-Csv -path $HOSTDSRelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $HOSTDSLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $HOSTDSLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

HOSTCLURELATION {

            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $HOSTCLURelDate = Get-Date
            $HOSTCLURelDate = $HOSTCLURelDate.ToString("yyyyMMdd")
            $HOSTCLURelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$HOSTCLURelDate+'_'+$Server+'.csv'
            $HOSTCLULogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$HOSTCLURelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $HOSTCLULogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $HOSTCLULogFileLoc
            Get-VMHost | Select Name, `
            @{N="Cluster";E={Get-Cluster -HOST $_}} | `
            Export-Csv -path $HOSTCLURelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $HOSTCLULogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $HOSTCLULogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

CLUDCRELATION {

            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Collecting' $CollectionType 'Relationship Data'
            $CLUDCRelDate = Get-Date
            $CLUDCRelDate = $CLUDCRelDate.ToString("yyyyMMdd")
            $CLUDCRelationFile = $uploadFolderPath.RELFileFolder+$CollectionType+'_'+$CLUDCRelDate+'_'+$Server+'.csv'
            $CLUDCLogFileLoc = $uploadFolderPath.LogFolder+$CollectionType+'_'+$CLUDCRelDate+'_'+$Server+'.log'
            ConnectVC -FunkVC $Server -FunkLogFileLoc $CLUDCLogFileLoc
            Log -Message "Starting Relationship collection for $CollectionType" -LogType "INFO" -LogFile $CLUDCLogFileLoc
            Get-Cluster | Select Name, `
            @{N="Datacenter";E={Get-Datacenter -CLUSTER $_}} | `
            Export-Csv -path $CLUDCRelationFile -NoTypeInformation
            Log -Message "Finished Relationship collection for $CollectionType" -LogType "INFO" -LogFile $CLUDCLogFileLoc
            DisconnectVC -FunkDCVC $Server -FunkDCLogFileLoc $CLUDCLogFileLoc
            Write-Host (Get-Date -UFormat '%m-%d-%Y %H:%M:%S') 'Finished Collecting' $CollectionType 'Relationship Data'
            }

default{"
 
        Usage:

        -----------------------------------------------
        Performance Metric Collection
        -----------------------------------------------

        VM Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCE'
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        HOST Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCE'	
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        DATASTORE Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'DATASTORE' -CollectionType 'PERFORMANCE'	
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'DATASTORE' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        CLUSTER Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCE'
		or
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCE' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'



        -----------------------------------------------
        Performance Real Time Collection - Collects Last hour of data from script execution.
        -----------------------------------------------
            Must be run within the hour otherwise the data will be rolled up and the array of objects to collect must go in the file Elementlist_'MetricSource'.csv
        
        VM Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'VM' -CollectionType 'PERFORMANCERT'

        HOST Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'HOST' -CollectionType 'PERFORMANCERT'	

        CLUSTER Collection
        .\PCLICollector.ps1 -Server vc.vMan.ch -MetricSource 'CLUSTER' -CollectionType 'PERFORMANCERT'


        -----------------------------------------------
        Performance Metric Collection from vROPS
        -----------------------------------------------

        VM Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'VM-OM' -CollectionType 'PERFORMANCEOM'
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'VM-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        HOST Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'HOST-OM' -CollectionType 'PERFORMANCEOM'	
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'HOST-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        DATASTORE Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'DATASTORE-OM' -CollectionType 'PERFORMANCEOM'	
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'DATASTORE-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        CLUSTER Collection
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'CLUSTER-OM' -CollectionType 'PERFORMANCEOM'
		or
        .\PCLICollector.ps1 -Server vrops.vMan.ch -MetricSource 'CLUSTER-OM' -CollectionType 'PERFORMANCEOM' -startdate '2016/03/15 18:00' -enddate '2016/03/15 00:00'


        -----------------------------------------------
        Inventory Collection
        -----------------------------------------------

        #Count of VM's per Datastore.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType DSVMCOUNT


        #Count of VM's per Host.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMHOSTCOUNT


        #Count of VM's per Cluster.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMCLUCOUNT


        #Sum of vCPU's USED per Host.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VCPUHOSTSUM


        #Sum of vCPU's USED per Cluster.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VCPUCLUSUM


        #Sum of vCPU's USED per VMVCPUS.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMVCPUS


        #Sum of vCPU's USED per VMVMEM.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMVMEM


        #Sum of vCPU's USED per HOSTMEM.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTMEM


        #Sum of vCPU's USED per HOSTCPUCORES.

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTCPUCORES



        -----------------------------------------------
        Relationship Collection
        -----------------------------------------------

        #VM to Datastore(s)

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMDSRELATION


        #VM to Cluster

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMCLURELATION


        #VM to HOST

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType VMHOSTRELATION


        #HOST to Datastore(s)

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTDSRELATION


        #HOST to Cluster

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType HOSTCLURELATION


        #Cluster to Datacenter

        .\PCLICollector.ps1 -Server vc.vMan.ch -CollectionType CLUDCRELATION

       "}
}