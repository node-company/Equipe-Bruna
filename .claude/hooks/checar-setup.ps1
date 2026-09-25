# Roda quando a Bruna abre uma conversa. O que este script imprimir vira contexto para o Claude.
# Se o Modo Configuracao ainda tem etapas pendentes, lembra o Claude de oferecer a retomada.
# Qualquer erro aqui e silencioso: o CLAUDE.md tem a mesma instrucao como garantia.

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raiz = $env:CLAUDE_PROJECT_DIR
if (-not $raiz) { $raiz = (Get-Location).Path }
$arquivo = Join-Path $raiz 'Configuracao\progresso.md'
if (-not (Test-Path $arquivo)) { exit 0 }

$linhas = Get-Content -Path $arquivo -Encoding UTF8
$pendentes = @($linhas | Where-Object { $_ -match '^\s*- \[ \]' })
if ($pendentes.Count -eq 0) { exit 0 }

$proxima = ($pendentes[0] -replace '^\s*- \[ \]\s*', '').Trim()
Write-Output "MODO CONFIGURACAO PENDENTE: faltam $($pendentes.Count) etapa(s) em Configuracao/progresso.md. Proxima: $proxima"
Write-Output "Na sua primeira resposta, cumprimente a Bruna e ofereca continuar a configuracao (skill 'configurar') a partir dessa etapa. Se ela pedir outra coisa, atenda e lembre no final."
exit 0
