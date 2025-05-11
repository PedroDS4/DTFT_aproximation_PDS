<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simulação Computacional 2 - Processamento Digital de Sinais</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .math-equation {
            font-family: 'Times New Roman', Times, serif;
            font-style: italic;
        }
        .code-block {
            font-family: 'Courier New', Courier, monospace;
            background-color: #f3f4f6;
            padding: 1rem;
            border-radius: 0.5rem;
            overflow-x: auto;
        }
        .figure-container {
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            padding: 1rem;
            margin: 1rem 0;
            background-color: #f9fafb;
        }
        .figure-title {
            font-weight: bold;
            text-align: center;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-800 font-sans p-6 max-w-6xl mx-auto">
    <header class="mb-8 border-b-2 border-blue-500 pb-4">
        <h1 class="text-3xl font-bold text-center text-blue-700">Simulação Computacional 2</h1>
        <h2 class="text-2xl font-semibold text-center mt-2">Processamento Digital de Sinais</h2>
        <div class="mt-4 text-center">
            <p class="text-lg"><span class="font-semibold">Aluno:</span> Pedro Arthur Oliveira dos Santos</p>
        </div>
    </header>

    <main class="space-y-8">
        <section class="bg-white p-6 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold mb-4 text-blue-600 border-b pb-2">Programação do código da transformada</h2>
            <p class="mb-4">Foi feita a inicialização dos vetores com os parâmetros requeridos, e usou-se um valor de M para o vetor de amostras de frequência igual a 200.</p>
            <p class="mb-4">O sinal <span class="math-equation">x[n] = (0.9exp(jπ/3))<sup>n</sup></span> tem suporte de [1,10], logo, podemos representa-lo usando uma subtração de degraus, assim:</p>
            <p class="math-equation mb-4 text-center">x[n] = (0.9exp(jπ/3))<sup>n</sup>(u[n] - u[n-11])</p>
            <p class="mb-4">Podemos separar em uma subtração e calcular a transformada de fourier para cada termo, pela linearidade.</p>
            <p class="math-equation mb-4 text-center">x[n] = (0.9exp(jπ/3))<sup>n</sup>u[n] - (0.9exp(jπ/3))<sup>n</sup>u[n-11]</p>
            <p class="mb-4">A primeira parcela tem transformada de fourier conhecida pela tabela, já na segunda precisamos fazer uma manipulação para deixar a função atrasada como um todo e usar a propriedade do deslocamento no tempo. Como opção, podemos multiplicar em cima e embaixo por (0.9exp(jπ/3))<sup>-11</sup> dessa maneira:</p>
            <p class="math-equation mb-4 text-center">x[n] = (0.9exp(jπ/3))<sup>n</sup>u[n] - (0.9exp(jπ/3))<sup>n-11</sup>u[n-11] (0.9exp(jπ/3))<sup>-11</sup></p>
            <p class="mb-4">Assim a transformada fica:</p>
            <p class="math-equation mb-4 text-center">X(e<sup>jw</sup>) = 1/(1-0.9e<sup>j(π/3-w)</sup>) - (0.9e<sup>jπ/3</sup>)<sup>11</sup>e<sup>-11jw</sup>/(1-0.9e<sup>j(π/3-w)</sup>)</p>
            
            <h3 class="text-xl font-semibold mt-6 mb-3 text-blue-500">Código do Octave:</h3>
            <div class="code-block mb-6">
                <pre>M = 200
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
xlabel('k'); ylabel('Fase (radianos)'); title('Fase de X(w)');</pre>
            </div>
        </section>

        <section class="bg-white p-6 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold mb-4 text-blue-600 border-b pb-2">Resultados</h2>
            
            <div class="mb-6">
                <h3 class="text-xl font-semibold mb-3 text-blue-500">Análise da aproximação</h3>
                <p class="mb-4">Podemos construir uma tabela com alguns valores e verificar o quão boa essa aproximação da DTFT é, como mostrado abaixo.</p>
                
                <div class="code-block mb-4">
                    <pre>#aproximando valores
function [Y] = tf_real(w)
    Y = (1/(1-0.9*exp(i*(pi/3 - w))) )*(1 - (0.9*exp(i*(pi/3 - w)))^11)
end

for i = 25:25:200
    fprintf('Transformada real(fase e módulo): %d, %d\n', abs(tf_real(i)), angle(tf_real(i)));
    fprintf('Transformada simulada(fase e módulo): %d, %d\n', modX(i), FaseX(i));
end</pre>
                </div>
                
                <p class="mb-4">Que tem como resultado a saída. Podemos ver que para alguns valores, como o de w = 150, a aproximação é boa, mas mesmo assim há distorções, principalmente na fase, porque o valor de M não é o valor ótimo que maximiza a eficiência dessa aproximação.</p>
            </div>
            
            <div>
                <h3 class="text-xl font-semibold mb-3 text-blue-500">Análise da paridade</h3>
                <p class="mb-4">Abaixo estão dispostos os gráficos de módulo e fase da transformada de fourier do sinal analisado, e podemos ver que ambos não possuem simetria par, nem ímpar, o que faz sentido, já que o sinal x[n] analisado não é puramente real.</p>
                
                <div class="grid md:grid-cols-2 gap-4 mt-6">
                    <div class="figure-container">
                        <div class="figure-title">Figura 1 - Gráfico do módulo de X(w)</div>
                        <div class="bg-gray-200 h-64 flex items-center justify-center">
                            <i class="fas fa-chart-line text-4xl text-blue-500"></i>
                            <p class="ml-3">Gráfico de magnitude</p>
                        </div>
                    </div>
                    
                    <div class="figure-container">
                        <div class="figure-title">Figura 2 - Gráfico da fase de X(w)</div>
                        <div class="bg-gray-200 h-64 flex items-center justify-center">
                            <i class="fas fa-chart-line text-4xl text-red-500"></i>
                            <p class="ml-3">Gráfico de fase</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="mt-12 pt-6 border-t border-gray-200 text-center text-gray-600">
        <p>Trabalho de Simulação Computacional 2 - Processamento Digital de Sinais</p>
        <p class="mt-2">Universidade - Departamento de Engenharia Elétrica</p>
        <p class="mt-4 text-sm">© 2023 Pedro Arthur Oliveira dos Santos</p>
    </footer>
</body>
</html>
