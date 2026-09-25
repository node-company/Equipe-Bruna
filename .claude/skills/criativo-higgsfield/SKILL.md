---
name: criativo-higgsfield
description: Passo a passo oficial para criar criativos (imagem de post, carrossel, story, capa de reels, cena de vídeo) no Higgsfield para Cardume, UNDIME ou SCP — do texto aprovado ao prompt de 7 elementos, geração pelo conector Higgsfield (ou prompt pronto para colar no site), ajuste cirúrgico, download e aprovação. Use sempre que a Bruna pedir arte, criativo, imagem ou vídeo gerado.
---

# Criativo no Higgsfield

## 0. Antes
- **Empresa** definida e base lida (`identidade.md`, `tom-de-voz.md`, `regras.md`; SCP:
  `regras-medicas.md`).
- **Texto aprovado** (em `Entregas/<Empresa>/copy/`). Sem texto, sem arte: primeiro o `copywriter`.
- Veja se já existe um prompt que deu certo em `Empresas/<Empresa>/prompts-aprovados.md`.
  Reaproveitar é mais rápido e mantém o feed coerente.

## 1. Montar o prompt (os 7 elementos)
Se faltar algum, a IA inventa, e inventa genérico.
1. **Formato e proporção:** 4:5 feed · 9:16 story/reels · 1:1 quadrado.
2. **Composição:** onde fica cada elemento e **onde fica o respiro** (área limpa para o texto e o logo
   entrarem depois no Canva).
3. **Texto:** a headline **não vai na geração** se tiver mais de ~4 palavras (a IA erra letra em
   português). Escreva no prompt "sem texto na imagem" e reserve o espaço.
4. **Paleta:** os hex de `identidade.md` da empresa.
5. **Luz e clima:** Cardume = corporativo premium, luz fria e controlada, rigor, nunca festa.
6. **Estilo:** fotografia real? ilustração low-poly? render 3D? textura abstrata?
7. **Logo:** **nunca** pedir para a IA desenhar. Reserve o canto onde ele entra.

Escreva o prompt **em inglês** (os modelos respondem melhor) e mostre à Bruna um resumo de
2 linhas **em português** do que vai sair. Pergunte: "Posso gerar 2 opções?" (cada geração gasta
créditos dela). Se ela já disse "pode gerar", siga.

### Modelo de prompt (adapte)
```
[FORMAT] Vertical 4:5 Instagram feed image, 1080x1350.
[SCENE] <o que aparece, em uma frase concreta>.
[COMPOSITION] Subject in the <lower/right> third; clean negative space in the <upper/left> area for a headline; bottom-right corner kept empty for a logo.
[PALETTE] Deep navy #0A1822 dominant, teal #1E857D, bioluminescent cyan #57E0D4 accents only, silver #C4D4D8.
[LIGHT & MOOD] Cool, controlled, premium corporate atmosphere; calm authority; not a party.
[STYLE] <photorealistic event photography | low-poly abyssal illustration | ...>, high detail, editorial.
[NO] No text, no letters, no logos, no watermarks, no confetti, no warm saturated colors.
```

## 2. Gerar
- **Com o conector Higgsfield ativo** (ferramentas `mcp__claude_ai_Higgsfield__*`): escolha o modelo
  adequado (imagem: o melhor modelo de imagem disponível; vídeo: Kling, Veo ou Seedance, de 5 a 10 s
  por cena), envie o prompt e **referências** se o conector aceitar imagem de referência (logo e
  1 ou 2 fotos de `Empresas/<Empresa>/identidade/`). Gere **2 opções** por padrão.
- A geração pode demorar: acompanhe o status pela ferramenta do conector até terminar.
- **Sem conector** (ou se der erro): entregue o prompt num bloco para ela copiar, com o passo a passo:
  "Abra higgsfield.ai → **Image** (ou **Video**) → cole o prompt → anexe o logo e 1 foto da pasta
  `Empresas\<Empresa>\identidade` → escolha a proporção → **Generate**." Depois ela arrasta o arquivo
  baixado para a pasta da peça (abra com `explorer.exe`).

## 3. Baixar e organizar
Crie `Entregas/<Empresa>/design/AAAA-MM-DD - <peça>/` e baixe cada resultado:
- PowerShell: `Invoke-WebRequest -Uri "<url>" -OutFile "<pasta>\opcao-1.png"`
- ou Bash: `curl -L -o "<pasta>/opcao-1.png" "<url>"`
Salve `prompt.md` com o prompt final, o modelo usado e os ajustes feitos.
Mostre as opções à Bruna (leia os arquivos para exibir) e pergunte: **"Qual fica: 1 ou 2? Ou quer
ajustar algo?"**

## 4. Ajustar (cirúrgico)
- Nunca "faz de novo" do zero. Diga o que **mantém** e o que **muda**: "mantém a composição e a
  paleta, só deixa a luz mais fria e tira as pessoas do fundo."
- Se o conector permitir, use a opção escolhida como referência da nova geração.
- Máximo de 3 rodadas antes de repensar o prompt com ela.

## 5. Checagem antes do "aprovado"
- Parece da empresa certa? (paleta, clima, estilo)
- Tem letra torta, logo inventado ou marca d'água? → ajustar.
- **Cardume:** sem clima de festa; nada que lembre stand de feira como serviço.
- **SCP:** nenhum corpo como "resultado", nada que pareça antes/depois. Se houver dúvida, não use.
- **UNDIME:** nenhuma criança identificável gerada como se fosse real; sem símbolo partidário.

## 6. Depois do "aprovado"
- Renomeie o arquivo escolhido para `aprovado.png` (ou `.mp4`).
- Adicione o prompt a `Empresas/<Empresa>/prompts-aprovados.md` (crie se não existir) com a data e
  1 linha sobre o uso. É a biblioteca de moldes dela.
- Se precisar de headline e logo por cima: diga exatamente o texto, a posição e a cor para ela fazer
  no **Canva** (2 minutos). Ela salva o resultado na mesma pasta.
- Próximo passo: skill `publicar-instagram`.
