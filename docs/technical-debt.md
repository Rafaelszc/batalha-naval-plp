# Dívida Técnica

Este relatório documenta pontos de melhoria, código morto e violações arquiteturais identificadas durante a análise do projeto.

## Lista de Problemas

1. **Uso de Variáveis Globais (`_G`)**:
   - Descrição: O compartilhamento de dados entre telas (nome do jogador, mapa selecionado, tabuleiro pré-posicionado) utiliza a tabela global `_G`.
   - Impacto: Alto. Quebra o encapsulamento, dificulta o rastreamento de bugs e viola princípios de modularidade.
   - Recomendação: Implementar um serviço de "Game Session" ou um sistema de passagem de parâmetros estruturado entre estados no `StateManager`.

2. **Acoplamento de View no Controller**:
   - Descrição: O `GameController` manipula a lógica de jogo, mas algumas interações exigem que se saiba o contexto de View para disparos.
   - Impacto: Médio.
   - Recomendação: Refinar a interface entre `GameController` e `Game` state para evitar vazamento de lógica de View.

3. **Falta de Testes Automatizados**:
   - Descrição: Não existem testes unitários para validar regras de negócio críticas (ex: lógica de afundar navio, cálculos de pontuação, validações de armas especiais).
   - Impacto: Alto. Alta suscetibilidade a regressões em futuras alterações.

4. **Código de UI Hardcoded**:
   - Descrição: As posições dos botões e elementos de UI no `Game` state e `Menu` state estão definidos de forma rígida (hardcoded).
   - Impacto: Baixo/Médio. Torna a adaptação a diferentes resoluções menos dinâmica.

---

## Possíveis Melhorias
- [ ] Implementar sistema de DI (Injeção de Dependência) para eliminar o uso de `_G`.
- [ ] Criar framework de testes (ex: `busted`) para validar `Board.lua` e `GameController.lua`.
- [ ] Refatorar UI para utilizar um sistema de layout relativo em vez de coordenadas absolutas.
