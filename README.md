# LaTeX UTFPR
---
Modelo para trabalhos acadêmicos em LaTeX desenvolvido pelos alunos do DAINF/UTFPR-PG.
---

---
## Informações gerais sobre o repo:
 * O modelo é distribuído no formato .dtx.
 * utfpr-pg.dtx é o arquivo principal que será distribuído aos usuários.

## Instruções de uso:
Com os arquivos utfpr-pg.dtx e Makefile na mesma pasta:
 1. execute ```make``` para gerar a documentação e arquivos de instalação.
 2. ```make install``` para instalar a classe em seu computador.

O arquivo utfpr-pg.pdf que será criado na etapa 1, contém informações adicionais de uso.


## Informações para desenvolvedores:
 * Pull requests somente no branch devel.
 * A wiki possui guias e manuais referentes às principais tecnologias utilizadas.

### Workflow básico:
 1. execute ```make``` para gerar a documentação e o arquivo da classe.
 2. dummy.tex é o arquivo para testes locais. Não fazer commit do mesmo.
 3. ```make dummy``` no diretório raiz do repo irá compilar o dummy com o utfpr-pg.cls da pasta raiz.

----
*Mantido por:*

Alunos do curso de
Bacharelado em Ciência da Computação.

Departamento de Informática.

Universidade Tecnológica Federal do Paraná,
Campus Ponta Grossa.

---

######Markdown edited with [dillinger](http://dillinger.io)
