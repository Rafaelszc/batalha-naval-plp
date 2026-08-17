# Fluxo de Execução

1. **`main.lua`**: Inicia o Love2D.
2. **`love.load()`**: Chama `StateManager.init("boot")`.
3. **`StateManager`**: Carrega e inicia o estado `boot`.
4. **Ciclo do Jogo (Loop)**:
   - `love.update(dt)`: Chama o `update` do estado atual (gerenciado por `StateManager`).
   - `love.draw()`: Chama o `draw` do estado atual (gerenciado por `StateManager`).
   - `love.mousepressed()`: Propaga o clique para o estado atual.

### Exemplo: Disparo do Jogador
1. `love.mousepressed()` -> `StateManager.mousepressed()`.
2. `Game:mousepressed()` detecta o clique no tabuleiro inimigo.
3. Chama `GameController:fire_weapon()`.
4. `GameController` atualiza `Board` (Model).
5. Na próxima iteração de `draw()`, a `BoardView` reflete a mudança.
