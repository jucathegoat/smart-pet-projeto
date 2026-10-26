
package com.petshop.backend.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "pet")
public class Pet {

    @Id
    @Column(name = "n_documento", nullable = false)
    private Integer nDocumento;

    @Column(name = "nome", nullable = false, length = 255)
    private String nome;

    @Column(name = "raca", nullable = false, length = 50)
    private String raca;

    @Column(name = "especie", nullable = false, length = 50)
    private String especie;

    @Column(name = "porte", length = 25)
    private String porte;

    @Column(name = "peso", precision = 5, scale = 2)
    private BigDecimal peso;

    @ManyToOne
    @JoinColumn(name = "cpf_cliente", nullable = false)
    private Cliente cliente;

    public Pet() {
    }
}

