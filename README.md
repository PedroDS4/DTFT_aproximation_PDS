# Simulação Computacional 2
## Processamento Digital de Sinais

**Aluno:** Pedro Arthur Oliveira dos Santos

---

## Programação do código da transformada

Foi feita a inicialização dos vetores com os parâmetros requeridos, e usou-se um valor de M para o vetor de amostras de frequência igual a 200.

O sinal $x[n] = (0.9exp(jπ/3))^n$ tem suporte de [1,10], logo, podemos representa-lo usando uma subtração de degraus, assim:

$x[n] = (0.9exp(jπ/3))^n(u[n] - u[n-11])$

Podemos separar em uma subtração e calcular a transformada de fourier para cada termo, pela linearidade.

$x[n] = (0.9exp(jπ/3))^nu[n] - (0.9exp(jπ/3))^nu[n-11]$

A primeira parcela tem transformada de fourier conhecida pela tabela, já na segunda precisamos fazer uma manipulação para deixar a função atrasada como um todo e usar a propriedade do deslocamento no tempo. Como opção, podemos multiplicar em cima e embaixo por $(0.9exp(jπ/3))^{-11}$ dessa maneira:

$x[n] = (0.9exp(jπ/3))^nu[n] - (0.9exp(jπ/3))^{n-11}u[n-11] (0.9exp(jπ/3))^{-11}$

Assim a transformada fica:

$X(e^{jw}) = \frac{1}{1-0.9e^{j(π/3-w)}} - \frac{(0.9e^{jπ/3})^{11}e^{-11jw}}{1-0.9e^{j(π/3-w)}}$

### Código do Octave:
```octave
M = 200
n0 = 1
nf = 10
n = n0:nf
k = zeros(1,2*M)
x = zeros(1,10)

function [z] = x1(n)
    z = (0.9*exp(i*pi/3))^n
end

for i =n0:nf
    n(i) = i
    x(i) = x1(n(i))
end

for i =1:2*M
    k(i) = -M+i-1
end

function [X] = dtft(x,n,k)
    M = 200
    X = zeros(M)
    X = x*exp(-1*i*pi*(n'*k)/M)
end

X = dtft(x,n,k)
disp(X)

modX = abs(X)
FaseX = angle(X)

figure
plot(k,modX,'cyan')
xlabel('k'); ylabel('Magnitude'); title('Magnitude de X(w)');

figure
plot(k,FaseX,'red')
xlabel('k'); ylabel('Fase (radianos)'); title('Fase de X(w)');

```

## Resultados

### Análise da aproximação
Podemos construir uma tabela com alguns valores e verificar o quão boa essa aproximação da DTFT é, como mostrado abaixo.

Que tem como resultado a saída. Podemos ver que para alguns valores, como o de w = 150, a aproximação é boa, mas mesmo assim há distorções, principalmente na fase, porque o valor de M não é o valor ótimo que maximiza a eficiência dessa aproximação.

### Análise da paridade
Abaixo estão dispostos os gráficos de módulo e fase da transformada de fourier do sinal analisado, e podemos ver que ambos não possuem simetria par, nem ímpar, o que faz sentido, já que o sinal x[n] analisado não é puramente real.

| | Figura 1 - Gráfico do módulo de X(w) | Figura 2 - Gráfico da fase de X(w) |
|---|---|---|
| **Gráfico** | ![Gráfico de magnitude](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=) (Gráfico de magnitude) | ![Gráfico de fase](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=) (Gráfico de fase) |


