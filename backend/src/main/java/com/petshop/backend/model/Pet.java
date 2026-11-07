package com.petshop.backend.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "pet")
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "nome", nullable = false, length = 255)
    private String nome;

    @Column(name = "raca", length = 50)
    private String raca;

    @Column(name = "especie", nullable = false, length = 50)
    private String especie;

    @Column(name = "idade")
    private Integer idade;

    @Column(name = "porte", length = 25)
    private String porte;

    @Column(name = "peso", precision = 5, scale = 2)
    private BigDecimal peso;

    @ManyToOne
    @JoinColumn(name = "cpf_cliente", nullable = false)
    private Cliente cliente;

    public Pet() {}

    public Pet(String nome, String raca, String especie, Integer idade, Cliente cliente) {
        this.nome = nome;
        this.raca = raca;
        this.especie = especie;
        this.idade = idade;
        this.cliente = cliente;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getRaca() { return raca; }
    public void setRaca(String raca) { this.raca = raca; }

    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }

    public Integer getIdade() { return idade; }
    public void setIdade(Integer idade) { this.idade = idade; }

    public String getPorte() { return porte; }
    public void setPorte(String porte) { this.porte = porte; }

    public BigDecimal getPeso() { return peso; }
    public void setPeso(BigDecimal peso) { this.peso = peso; }

    public Cliente getCliente() { return cliente; }
    public void setCliente(Cliente cliente) { this.cliente = cliente; }
}