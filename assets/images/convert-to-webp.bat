@echo off
for %%F in (*) do (
  if %%~xF==.png (
    cwebp -q 80 "%%~nxF" -o "%%~nF.webp"
    del "%%F"
  )
  if %%~xF==.jpg (
    cwebp -q 80 "%%~nxF" -o "%%~nF.webp"
    del "%%F"
  )
)