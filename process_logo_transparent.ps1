Add-Type -AssemblyName System.Drawing

$inputPath = "C:\Users\Flavio Souza\.gemini\antigravity\scratch\EletricistaSantosWebsite\assets\logo.png"
$outputPath = "C:\Users\Flavio Souza\.gemini\antigravity\scratch\EletricistaSantosWebsite\assets\logo_transparent.png"

try {
    $img = [System.Drawing.Bitmap]::FromFile($inputPath)
    $bmp = New-Object System.Drawing.Bitmap($img)
    $img.Dispose()

    $width = $bmp.Width
    $height = $bmp.Height

    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            $pixel = $bmp.GetPixel($x, $y)
            $r = $pixel.R
            $g = $pixel.G
            $b = $pixel.B
            $a = $pixel.A
            
            # Find max and min RGB values
            $max = [Math]::Max($r, [Math]::Max($g, $b))
            $min = [Math]::Min($r, [Math]::Min($g, $b))
            $diff = $max - $min
            
            # If the pixel is very bright and has low saturation (i.e. it's white or light gray from the grid)
            # Make it fully transparent (Alpha = 0)
            if ($max -gt 180 -and $diff -lt 40) {
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            } 
        }
    }

    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Success"
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
