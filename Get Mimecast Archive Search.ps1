# /api/archive/search

#Setup required variables
$baseUrl = "https://eu-api.mimecast.com"
$accessKey = "mYtOL3XZCOwG96BOiFTZRurf88Sfl2RfnR8aAziZ_JflEAqR7fyfYOgY4VL4qQusYeSKWTi58d5rImDdUPTXyT4q1C-H_90DZQz6DSeFZFMElIsrwyBdUlzRXMHCJAjpuO-j6TeRwvJX7s2gV-pkwA"
$secretKey = "Mfd1MXe2u/ypIpL+QYIqJg5SdT/Drp+erT2AMtVw3XrAJl7pnT9OVnk3tJeb33ewCL8q5SrB1ETFDqdpmCEkLw=="
$appId = "abf84d51-b466-4f1d-a6c1-2d04fe3f0399"
$appKey = "7ce8ebb6-dae1-45b2-8b6c-ddd384341eb2"
$uri = "/api/archive/search"
$url = $baseUrl + $uri
 
#Generate request header values
$hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
$requestId = [guid]::NewGuid().guid
 
#Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
$sha = New-Object System.Security.Cryptography.HMACSHA1
$sha.key = [Convert]::FromBase64String($secretKey)
$sig = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($hdrDate + ":" + $requestId + ":" + $uri + ":" + $appKey))
$sig = [Convert]::ToBase64String($sig)
 
#Create Headers
$headers = @{"Authorization" = "MC " + $accessKey + ":" + $sig;
                "x-mc-date" = $hdrDate;
                "x-mc-app-id" = $appId;
                "x-mc-req-id" = $requestId;
                "Content-Type" = "application/json"}
 
#Create post body
$postBody = "{
                 ""data"":[
                        {
                            ""admin"": True,
                            ""query"": ""<?xml version=\""1.0\""?>
                                        <xmlquery trace=\""iql,muse\"">
                                        <metadata query-type=\""emailarchive\"" archive=\""true\"" active=\""false\"" page-size=\""5\"" startrow=\""0\"">
                                        <mailboxes>
                                            <mailbox include-aliases=\""true\"">judd@panoptics.com</mailbox>
                                        </mailboxes>
                                        <smartfolders/>
                                        <return-fields>
                                        <return-field>attachmentcount</return-field>
                                        <return-field>status</return-field>
                                        <return-field>subject</return-field>
                                        <return-field>size</return-field>
                                        <return-field>receiveddate</return-field>
                                        <return-field>displayfrom</return-field>
                                        <return-field>id</return-field>
                                        <return-field>displayto</return-field>
                                        <return-field>smash</return-field>
                                        </return-fields>
                                        </metadata>
                                        <muse>
                                        <text>talon</text>
                                        <date select=\""last_year\""/>
                                        </muse>
                                        </xmlquery>""
                        }
                    ]
                }"
 
#Send Request
$response = Invoke-RestMethod -Method Post -Headers $headers -Body $postBody -Uri $url
 
#Print the response
($response.data.items | ? {$_.smash -eq "3a57d4890c77bb2409b98d18c211a8e8ca5cc1c7"}).displayto
