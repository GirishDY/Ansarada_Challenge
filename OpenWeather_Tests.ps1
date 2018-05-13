param(

  #[Parameter(Mandatory)]

  [ValidateNotNullOrEmpty()]

  [string]$APIKey,

  #[Parameter(Mandatory)]

  [ValidateNotNullOrEmpty()]

  [string]$ResMo

  )

if(!$ResMo){ $ResMo = "json"}   #Setting default value.

$uri = "http://api.openweathermap.org/data/2.5/weather?q=Sydney&APPID=$APIKey&mode=$ResMo"

Describe  'Open Weathr API tests' {

    Context 'Running test for open weather API' {



It 'API response format should be JSON/XML' {

 if($ResMo -eq "json" -or $ResMo -eq "xml"){
    $x=1
    }
 else{
  $x = 0
     }

     $x | Should be 1


      }


It 'Return 401 if right api key is not passed' {

          try{

          $response = Invoke-RestMethod -Uri $uri

          Write-Host "Skipping this tests as right key has been passed"

          }
          catch{

          $_.Exception.Response.StatusCode.value__ | Should be 401

          }


}


try{

$response = Invoke-RestMethod -Uri $uri

}
catch{

Write-Host "Skipping Rest of the test cases as key is not correct"

return

}


It 'City is Sydney ' {

   if($ResMo -eq "json"){
   $response.name | Should be Sydney
    }
    elseif($ResMo -eq "xml"){
       $response.current.city.name | Should be Sydney
    }else{

  $ResMo | Should Contain xml/json

    }


}




It 'Temprature is more than 10 degree ' {

# API response contains temprture in °C .  0 °C = 0 + 273 Kelvin
if($ResMo -eq "json"){

   $response.main.temp | Should BeGreaterThan 280
}
elseif($ResMo -eq "xml"){
    $response.current.temperature.value | Should BeGreaterThan 280
    }
else{
  $ResMo | Should Contain xml/json
    }

}



It 'Day is Thursday ' {

   $date = get-date "1/1/1970"
   $date.AddSeconds($unixTime).ToLocalTime().DayOfWeek | Should be Friday


}

    }

}
