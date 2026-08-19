# Batalha Naval - Documentação Técnica

## Objetivo
O presente documento serve como guia de arquitetura e implementação do projeto Batalha Naval, desenvolvido em Lua utilizando o framework Love2D. O sistema foi projetado seguindo padrões modernos de desenvolvimento para garantir escalabilidade e manutenibilidade.

## Tecnologias
- Lua
- Love2D
- SQLite (lsqlite3)

## Arquitetura
O sistema adota o padrão **MVC (Model-View-Controller)**, mediado por um **State Manager**.

## Estrutura de Diretórios
```
/
├── assets/
├── docs/ (Documentação)
├── src/
│   ├── core/ (State Manager)
│   ├── controllers/ (Lógica de Jogo)
│   ├── models/ (Entidades)
│   ├── views/ (Renderização)
│   ├── services/ (IA, Armas)
│   ├── database/ (Persistência)
│   ├── states/ (Máquina de estados)
│   └── utils/ (UI)
└── main.lua
```

## Usabilidade
Esse projeto possui as seguintes dependências

| Nome | Versão |
| --- | --- |
| Lua | 5.8.4 |
| luarocks | 3.9.2 |
| lsqlite | 0.9.6 |
| LOVE | 11.5 |
 