package com.petshop.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "caixa")
public class Caixa {

    @Id
    @Column(name = "id_caixa")
    private Integer idCaixa;

    @ManyToOne
    @JoinColumn(name = "matricula_funcionario")
    private Funcionario funcionario;

    public Caixa() {
    }
}