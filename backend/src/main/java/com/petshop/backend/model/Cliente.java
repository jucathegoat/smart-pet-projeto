
package com.petshop.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "cliente")
public class Cliente {

    @Id
    @Column(name = "cpf")
    private Integer cpf;

    @Column(name = "nome", nullable = false, length = 255)
    private String nome;

    @Column(name = "telefone", nullable = false)
    private Integer telefone;

    @Column(name = "endereco", nullable = false, length = 255)
    private String endereco;

    public Cliente() {
    }
}
