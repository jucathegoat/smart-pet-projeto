<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Fila de Atendimento - Smart Pet Admin</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="logo">🐾 Smart Pet Admin</div>
        <nav>
            <a href="FilaServlet" class="active">Fila em Tempo Real</a>
            <a href="clientes.jsp">Consultar Clientes</a>
        </nav>
    </header>

    <main class="container">
        <h2>Fila de Atendimento</h2>

        <!-- Botão que envia a requisição direta para o Java -->
        <div class="acoes-topo">
            <form action="FilaServlet" method="POST">
                <input type="hidden" name="acao" value="chamarProximo">
                <button type="submit" class="btn btn-sucesso">📢 Chamar Próximo Paciente</button>
            </form>
        </div>

        <table class="tabela">
            <thead>
                <tr>
                    <th>Posição</th>
                    <th>Cliente</th>
                    <th>Pet</th>
                    <th>Serviço</th>
                    <th>Chegada</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${listaFila}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${item.nomeCliente}</td>
                        <td>${item.nomePet}</td>
                        <td>${item.servico}</td>
                        <td>${item.horarioChegada}</td>
                        <td><span class="badge ${item.statusClass}">${item.status}</span></td>
                        <td>
                            <!-- Formulário direto para cancelamento com justificativa obrigatória nativa -->
                            <form action="FilaServlet" method="POST" style="display:inline-block;">
                                <input type="hidden" name="acao" value="cancelar">
                                <input type="hidden" name="idAtendimento" value="${item.id}">
                                <input type="text" name="motivo" placeholder="Motivo do cancelamento" required class="input-inline">
                                <button type="submit" class="btn btn-perigo">Cancelar</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</body>
</html>