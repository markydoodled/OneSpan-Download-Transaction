# Set the API key and base URL
$apiKey = "your_api_key"
$apiUrl = "https://apps.esignlive.eu/api/packages"

# Create headers for authentication
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $apiKey")

# Function to retrieve information about a specific document in a transaction and download its PDF version
function Get-DocumentInfoAndDownloadPDF {
    param (
        [string]$transactionId,
        [string]$documentId
    )
    
    $documentInfoUrl = "$apiUrl/$transactionId/documents/$documentId"
    $documentPdfUrl = "$documentInfoUrl/pdf"
    
    try {
        # Retrieve information about the specified document
        $response = Invoke-RestMethod -Uri $documentInfoUrl -Headers $headers -Method Get
        Write-Output "Document Information Retrieved Successfully:"
        Write-Output $response | ConvertTo-Json -Depth 5
        
        # Download the PDF version of the document
        $pdfFileName = "$($documentId).pdf"
        Invoke-RestMethod -Uri $documentPdfUrl -Headers $headers -Method Get -OutFile $pdfFileName
        Write-Output "PDF Document Downloaded Successfully: $pdfFileName"
    } catch {
        Write-Output "Failed to retrieve document information or download PDF. Error: $_"
    }
}

# Prompt user for transaction ID and document ID
$transactionId = Read-Host -Prompt "Enter the transaction ID"
$documentId = Read-Host -Prompt "Enter the document ID"

# Retrieve information about the specified document and download its PDF version
Get-DocumentInfoAndDownloadPDF -transactionId $transactionId -documentId $documentId

Read-Host -Prompt "Press any key to close the window..."
