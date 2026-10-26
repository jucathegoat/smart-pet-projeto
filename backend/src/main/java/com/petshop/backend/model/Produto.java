
package com.petshop.backend.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "produto")
public class Produto {

    @Id
    @Column(name = "codigo", nullable = false)
    private Integer codigo;

    @Column(name = "nome", nullable = false, length = 255)
    private String nome;

    @Column(name = "marca", nullable = false, length = 255)
    private String marca;

    @Column(name = "estoque", nullable = false)
    private Integer estoque;

    @Column(name = "preco", nullable = false, precision = 10, scale = 2)
    private BigDecimal preco;

    //CONSTRUTOR
    public Produto() {
    }

    public Integer getCodigo() {
        return codigo;
    }

    public String getNome() {
        return nome;
    }

    public String getMarca() {
        return marca;
    }

    public Integer getEstoque() {
        return estoque;
    }

    public BigDecimal getPreco() {
        return preco;
    }
}
