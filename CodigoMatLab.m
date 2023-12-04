clear;
close all;
clc;

% Configura a porta serial
s = serial('COM3', 'BaudRate', 9600); % Abre a porta serial
fopen(s);

% Inicializa os vetores de dados e os gráficos
maxSamples = 10; % Número máximo de amostras a serem exibidas
dataIluminancia = zeros(1, maxSamples);
dataUV = zeros(1, maxSamples);

% Inicializa os gráficos
figure(1);

subplot(2, 1, 1);
hIluminancia = plot(dataIluminancia);
xlabel('Amostras');
ylabel('Iluminância');
title('Gráfico em Tempo Real - Iluminância');
axis([1 maxSamples 0 700]);

subplot(2, 1, 2);
hUV = plot(dataUV);
xlabel('Amostras');
ylabel('Raios UV (mW/cm^2)');
title('Gráfico em Tempo Real - Raios UV');
axis([1 maxSamples 0 20]);

% Inicializa a tabela (vazia)
tabelaDados = table('Size', [maxSamples, 2], 'VariableTypes', {'double', 'double'}, ...
    'VariableNames', {'Iluminancia', 'UV'});

% Loop para atualizar os gráficos e a tabela em tempo real
idx = 1; % Índice para controlar a posição atual nos vetores de dados
while ishandle(hIluminancia) && ishandle(hUV)
    % Lê os dados da porta serial
    dados = str2double(strsplit(fgetl(s), ',')); % Assume que os dados são separados por vírgula

    % Atualiza os vetores de dados
    dataIluminancia(idx) = dados(1); % Valor de iluminância
    dataUV(idx) = dados(2); % Valor de raios UV

    % Atualiza os gráficos
    set(hIluminancia, 'YData', dataIluminancia);
    set(hUV, 'YData', dataUV);
    drawnow;

    % Atualiza a tabela
    tabelaDados(idx, :) = {dados(1), dados(2)};
    disp(tabelaDados);
    
    % Atualiza o índice
    idx = idx + 1;
    if idx > maxSamples
        idx = 1; % Volta para o início quando o limite é atingido
        dataUV = zeros(1, maxSamples); % Zera os gráficos e tabela
        dataIluminancia = zeros(1, maxSamples);
        tabelaDados{:,1} = zeros(1, maxSamples).';
        tabelaDados{:,2} = zeros(1, maxSamples).';
    end
end

% Fecha a porta serial quando os gráficos são fechados
fclose(s);
delete(s);
clear s;