---
name: publicar-instagram
description: Depois que a Bruna aprova um post (imagem, carrossel, reels ou story), deixa tudo pronto para agendar no Instagram da empresa certa pelo Meta Business Suite — pasta organizada, legenda copiada para a área de transferência, horário sugerido e passo a passo em cliques. Use quando ela disser "aprovado", "pode publicar", "agenda esse post".
---

# Publicar no Instagram (semiautomático)

Não existe conexão direta com o Instagram: **quem clica em "Agendar" é a Bruna.** O seu trabalho é
deixar isso a 2 minutos de distância.

## 1. Conferir
- **Empresa** e **@** de destino (de `Empresas/<Empresa>/_base/empresa.md`). Diga em voz alta:
  "Este post vai para o **@____** (Cardume)." Postar no perfil errado é o pior erro possível aqui.
- Mídia aprovada existe? Legenda aprovada existe? Se faltar algo, pare e diga o quê.
- **SCP:** o médico responsável aprovou? Se não, o pacote fica pronto mas marcado "aguardando
  aprovação do médico".

## 2. Montar o pacote
Pasta: `Entregas/<Empresa>/aprovados/AAAA-MM-DD - <tema>/`
- Copie a(s) mídia(s) aprovada(s), numeradas na ordem do carrossel: `1.png`, `2.png`…
- `legenda.txt`: a legenda final, pronta, com as hashtags no fim.
- `publicar.md`: @ de destino, formato, data e horário sugeridos, e o que falta (se faltar algo).

## 3. Facilitar para ela
- Copie a legenda para a área de transferência:
  `Get-Content -Raw -Encoding UTF8 "<pasta>\legenda.txt" | Set-Clipboard`
  e avise: **"A legenda já está copiada. É só colar com Ctrl + V."**
- Abra a pasta do pacote: `explorer.exe "<pasta>"`
- Sugira **1 horário** (dia e hora) com uma justificativa curta, a partir do calendário do
  `social-media` se existir.

## 4. Passo a passo (mande assim, curto)
**No computador (Meta Business Suite):**
1. Abra **business.facebook.com** e, no canto superior esquerdo, escolha **<empresa>**.
2. Clique em **Criar publicação** (ou **Criar story** / **Criar reel**).
3. Em "Publicar em", deixe **só o Instagram @____** marcado (desmarque o Facebook se não quiser lá).
4. **Adicionar foto/vídeo** → **Carregar do computador** → selecione os arquivos da pasta que abriu
   (na ordem 1, 2, 3…).
5. Clique na caixa de texto e cole a legenda (**Ctrl + V**).
6. Embaixo, ao lado de "Publicar", clique na setinha → **Programar** → escolha **<dia> às <hora>** →
   **Programar**.

**Pelo celular (alternativa):** no app do Instagram do perfil certo → **+** → escolha a mídia →
**Avançar** → cole a legenda → **Configurações avançadas** / **Programar** → escolha a data →
**Programar**. (Para mandar os arquivos para o celular, ela pode usar o Google Drive.)

## 5. Fechar
Pergunte: "Conseguiu programar?" Quando ela confirmar:
- Registre em `Entregas/<Empresa>/aprovados/registro.csv` (crie se não existir):
  `data_publicacao;empresa;perfil;formato;tema;pasta` (separador `;`).
- Se ela travar em alguma tela, peça um print (Windows + Shift + S, depois Ctrl + V aqui).
