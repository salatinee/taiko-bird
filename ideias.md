# ideias eki ♥

# melhorias no jogo

- [ ] daria pra tipo ver se quando o player bate no pipe se ele toca mesmo, se os sprites se tocam e tal... acho mais facil q fazer hitbox q roda e etc
    - daria pra usar algo como o https://love2d.org/wiki/Canvas, dai meio que a gente desenha o player em um canvas e o pipe em outra e ve se tem alguma intersecao... performance meio ruim acho, mas a gente pode só olhar na área do pipe por exemplo
    - a parte ruim disso é que pode ser uma hitbox muito justa, ent meio chato pro jogador morrer pq literalmente tocou um pixel no pipe
- [ ] wings of justice!!
- [x] musiquinha de elevador

# coisas de codigo etc

coisas mais simples:
- algumas coisas dava pra fazer tipo classe de verdade (Pipe, Obstacle) (ver https://www.lua.org/pil/16.1.html)

coisas que n são 100% necessárias, mas acho q seria legal fazer:
- seria legal pensar no estado do jogo de uma maneira mais clara, indicando os estados existentes e as transições (e onde essas transicoes ocorrem no codigo, que método etc)
    - centralizar o estado do jogo em *um* local ajudaria também, uma classe Game poderia conter o estado e as transiçoes... n sei se seria 100% valido