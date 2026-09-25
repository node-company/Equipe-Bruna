---
name: configurar
description: Modo Configuração da equipe da Bruna — entrevista sobre Cardume, UNDIME e SCP para completar as bases, e tutorial passo a passo para conectar Google (Drive, Gmail, Agenda), Higgsfield e preparar os Instagram no Meta Business Suite. Use na primeira conversa, quando Configuracao/progresso.md tiver etapas pendentes, ou quando a Bruna disser "configurar", "continuar configuração", "conectar minhas contas".
---

# Modo Configuração

Você vai conduzir a Bruna, uma etapa de cada vez, até a equipe estar pronta. Ela tem pouco tempo:
**cada etapa leva de 5 a 10 minutos, é salva ao terminar e pode ser interrompida a qualquer momento.**

## Como conduzir (vale para todas as etapas)
- Leia `Configuracao/progresso.md` e comece pela **primeira etapa com `[ ]`**.
- Ao abrir, diga em uma linha onde ela está ("Estamos na etapa 3 de 8: conhecer a UNDIME, uns
  10 minutos.") e pergunte se quer seguir agora ou deixar para depois.
- **Uma pergunta por vez** (no máximo duas, se forem curtas). Prefira opções numeradas.
- Aceite "não sei" e "depois": marque `[CONFIRMAR]` no arquivo e siga em frente.
- **Salve à medida que ela responde**: escreva direto nos arquivos `Empresas/<Empresa>/_base/`,
  trocando o `[PREENCHER NO SETUP]` correspondente. Não acumule tudo para o fim.
- Ao fechar a etapa: marque `[x]` em `progresso.md`, resuma em 2 ou 3 linhas o que ficou salvo e
  pergunte se ela quer seguir para a próxima.
- Se algo travar numa tela, peça um print: **"aperte Windows + Shift + S, selecione a tela e cole
  aqui com Ctrl + V"**. Leia o print e diga o próximo clique.
- Os nomes dos botões podem mudar um pouco com atualizações do app. Se o que ela vê for diferente
  do roteiro, peça o print e adapte.
- Nunca peça senha. Se ela colar uma, avise para trocar e não repita.

---

## Etapa 1 · Boas-vindas (3 min)
Explique em até 6 linhas:
- Ela tem uma **equipe de 12 especialistas** (cite 4 ou 5 com exemplos: "pede ao social-media o
  calendário da semana da Cardume").
- Basta **escrever normalmente**, dizendo de qual empresa é o pedido.
- **Nada é publicado ou enviado sem o "aprovado" dela.**
- Se ficar perdida, é só escrever **"ajuda"**.
- Quando o app pedir permissão ("Permitir?"), é o Claude pedindo licença para agir; pode aceitar
  quando o pedido fizer sentido com o que ela pediu.
Pergunte como ela prefere ser chamada e se quer respostas mais curtas ou mais detalhadas. Salve a
preferência em `Configuracao/progresso.md`, seção "Anotações do setup".

## Etapa 2 · Cardume (10 min)
A base da Cardume **já veio preenchida** com o que foi decidido nas reuniões. Não repergunte o que
já está lá. Faça só:
1. Mostre em 5 linhas o resumo do que já está salvo (linha pública, cinco linhas, 365, ecossistema,
   regras principais) e pergunte: "Tem alguma coisa aqui que mudou?"
2. Preencha as lacunas, uma por vez:
   - @ do Instagram, site, WhatsApp comercial, LinkedIn → `empresa.md`
   - Preços ou faixas de preço de cada linha (ou "prefiro não colocar") → `ofertas.md`
   - Números reais dos últimos eventos (se houver) → `cases.md`
   - Os cases "Congresso Nacional B2B", "Lançamento Premium", "Feira Setorial" são reais? → `cases.md`
   - Metas (faturamento, contratos 365, verba de anúncio, horas por semana) → `metas.md`
   - Quem não é cliente (desqualificação) → `icp.md`
   - Pilares de conteúdo: mostre os de `.claude/agents/social-media.md` e pergunte se valem → `empresa.md`

## Etapa 3 · UNDIME (10 min)
Preencha `Empresas/UNDIME/_base/`. Perguntas, uma por vez:
1. É a UNDIME nacional ou a seccional de algum estado?
2. Em uma frase, o que a UNDIME faz, do jeito que ela mesma se apresenta?
3. O que você faz lá? (só redes sociais? eventos? outros materiais?) Quem aprova antes de publicar?
4. Quem é o público das redes? (dirigentes, secretarias, professores, imprensa…)
5. @ do Instagram, site e outras redes.
6. Tom de voz: "Me mande o link de 2 ou 3 posts que têm a cara da UNDIME." (Leia os links se
   abrirem; se não, peça para ela descrever.) → `tom-de-voz.md`
7. Regras: palavras proibidas, assinatura obrigatória, hashtags oficiais, cuidado em ano eleitoral.
8. Datas fortes do ano (fóruns, encontros, campanhas) → `empresa.md`
9. Cores e fontes oficiais, se ela souber → `identidade.md`
10. **Logos:** abra a pasta para ela com
    `explorer.exe "<raiz>\Empresas\UNDIME\identidade"` (crie `logos\` e `fotos\` antes) e peça:
    "Arraste para a pasta **logos** os arquivos do logo da UNDIME, e para **fotos** algumas fotos
    boas de eventos." Confira depois se os arquivos chegaram.

## Etapa 4 · SCP (10 min)
Preencha `Empresas/SCP/_base/`. Lembre à Bruna: **para a SCP a equipe cuida só do conteúdo das
redes.** Perguntas:
1. Nome como aparece nas redes, cidade, @.
2. Médico(s) que aparecem no conteúdo: nome, CRM/UF e RQE. Quem é o diretor técnico?
3. Onde esses dados entram no post: na legenda, na arte ou só na bio? (Explique em uma linha que é
   exigência do CFM.)
4. Procedimentos que a SCP quer divulgar, e os que não quer.
5. O médico já tem regras próprias? (ex.: não mostrar antes e depois, não falar de preço)
6. Quem aprova antes de publicar? (o médico sempre deve aprovar conteúdo médico)
7. Tom de voz: 2 ou 3 posts de exemplo.
8. Cores, fontes, logos e fotos (mesmo processo da UNDIME, pasta `Empresas\SCP\identidade`).
Mostre em 3 linhas os pontos principais de `regras-medicas.md` e pergunte se o médico tem alguma
regra a mais.

## Etapa 5 · Google (8 min)
Objetivo: conectar **Google Drive, Gmail e Google Agenda** na conta do Claude dela.
Roteiro para ela (um passo por mensagem, espere o "feito"):
1. No app do Claude, clique no **seu nome** (canto inferior esquerdo) → **Configurações**.
2. Clique em **Conectores**.
3. Procure **Google Drive** e clique em **Conectar**. Vai abrir o navegador: entre com a conta Google
   que você usa para trabalho e clique em **Permitir**.
4. Repita para **Gmail** e para **Google Calendar (Agenda)**.
5. Volte para esta conversa. **Pode ser preciso abrir uma conversa nova** para o Claude enxergar as
   conexões: se for o caso, ela abre uma nova e digita "continuar configuração".
**Teste:** liste 3 arquivos recentes do Drive e o próximo compromisso da agenda. Se funcionar,
comemore em uma linha. Explique: e-mail o Claude só deixa como **rascunho**, e compromisso só marca
com o "pode marcar" dela.
Se ela usa contas Google diferentes por empresa, anote qual está conectada em "Anotações do setup".

## Etapa 6 · Higgsfield (8 min)
Pré-requisito: ela já tem conta no Higgsfield (se não tiver, oriente a criar em higgsfield.ai e
volte aqui depois).
1. **Configurações** → **Conectores** → **Adicionar conector personalizado**.
2. Nome: **Higgsfield** (escrito assim). Endereço: **https://mcp.higgsfield.ai/mcp**
3. Clique em **Adicionar** e depois em **Conectar**. Faça login no Higgsfield e clique em **Permitir**.
4. Abra uma conversa nova se preciso e digite "continuar configuração".
**Teste:** gere **1** imagem simples da Cardume (ex.: fundo abissal com cardume de sardinhas, 4:5,
paleta de `Empresas/Cardume/_base/identidade.md`), baixe para `Entregas/Cardume/design/` e mostre.
Explique: **cada geração gasta créditos** do plano dela; por isso a equipe mostra o prompt antes e
gera poucas opções (2 por padrão).
Se o conector não funcionar, não trave: a equipe entrega o prompt pronto para ela colar no site do
Higgsfield. Anote em "Anotações do setup".

## Etapa 7 · Instagram (10 min)
Não há conexão direta: a publicação é **agendada pelo Meta Business Suite**, com legenda e mídia
prontas. Para cada perfil (Cardume, UNDIME, SCP), confira:
1. **É conta profissional?** No app do Instagram: perfil → ☰ → **Tipo de conta e ferramentas**.
   Se aparecer "Mudar para conta profissional", ainda é pessoal (oriente a mudar para **Empresa**).
2. **Está ligada a uma Página do Facebook?** Abra **business.facebook.com** no computador. No canto
   superior esquerdo, clique no nome da conta: as três empresas aparecem na lista?
3. Para cada uma que **não** aparecer: ela precisa que o dono da página/perfil a adicione. Escreva
   para ela uma **mensagem pronta** para mandar a essa pessoa, explicando o caminho: Meta Business
   Suite → Configurações → Pessoas → Adicionar → e-mail da Bruna → acesso total ao Instagram.
   Marque como pendente em "Anotações do setup" e siga.
4. Mostre uma vez como agendar (é o mesmo passo a passo da skill `publicar-instagram`).
Salve os @ confirmados nos `empresa.md`.

## Etapa 8 · Teste completo (10 min)
Faça um post real da Cardume do começo ao fim, mostrando o fluxo que ela vai usar sempre:
1. `social-media`: 1 pauta. 2. `copywriter`: legenda + texto da arte. 3. `designer`: criativo no
Higgsfield (skill `criativo-higgsfield`). 4. Ela aprova. 5. Skill `publicar-instagram`.
No fim: marque `[x]`, parabenize em uma linha e mostre **3 pedidos** que ela pode fazer amanhã
(um por empresa). Diga que para rever tudo isso é só digitar **"ajuda"**.

---

## Quando tudo estiver `[x]`
Escreva no topo de `Configuracao/progresso.md`: `Setup concluído em AAAA-MM-DD.` A partir daí o
hook e o CLAUDE.md param de oferecer o setup. Se depois ela quiser refazer uma etapa (ex.: trocou
de conta do Google), é só pedir: "refazer a etapa 5".
