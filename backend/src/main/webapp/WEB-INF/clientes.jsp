<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Consulta de Clientes - Smart Pet Admin</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="logo">🐾 Smart Pet Admin</div>
        <nav>
            <a href="FilaServlet">Fila em Tempo Real</a>
            <a href="clientes.jsp" class="active">Consultar Clientes</a>
        </nav>
    </header>

    <main class="container">
        <h2>Consulta e Gestão de Clientes</h2>

        <!-- Busca por CPF -->
        <section class="card-busca">
            <form action="ClienteServlet" method="GET" class="form-inline">
                <input type="hidden" name="acao" value="consultar">
                <div class="form-group">
                    <label for="cpf">Digite o CPF do Cliente:</label>
                    <input type="text" id="cpf" name="cpf" placeholder="000.000.000-00" required>
                </div>
                <button type="submit" class="btn btn-primario">🔍 Pesquisar</button>
            </form>
        </section>

        <!-- Mensagens renderizadas dinamicamente pelo Java -->
        <c:if test="${not empty mensagemErro}">
            <div class="alerta alerta-erro">${mensagemErro}</div>
        </c:if>

        <c:if test="${not empty cliente}">
            <section class="card-detalhes">
                <h3>${cliente.nome}</h3>
                <p><strong>CPF:</strong> ${cliente.cpf}</p>
                <p><strong>Status:</strong> ${cliente.status}</p>

                <!-- Formulário de Bloqueio sem JavaScript -->
                <c:if test="${cliente.status != 'BLOQUEADO'}">
                    <form action="ClienteServlet" method="POST" class="form-bloqueio">
                        <input type="hidden" name="acao" value="bloquear">
                        <input type="hidden" name="cpf" value="${cliente.cpf}">

                        <label for="motivo">Motivo do Bloqueio (Obrigatório):</label>
                        <textarea id="motivo" name="motivo" rows="3" required placeholder="Digite a justificativa..."></textarea>

                        <button type="submit" class="btn btn-perigo">🚫 Bloquear Cliente</button>
                    </form>
                </c:if>
            </section>
        </c:if>
    </main>
</body>
</html>