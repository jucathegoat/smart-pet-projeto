
package com.petshop.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "avaliacao")
public class Avaliacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_aval")
    private Integer idAval;

    @Column(name = "nota")
    private Integer nota;

    @Column(name = "aval_data")
    private LocalDateTime avalData;

    @Column(name = "comentario")
    private String comentario;

    public Avaliacao() {}

    public Integer getIdAval() {
        return idAval;
    }

    public void setIdAval(Integer idAval) {
        this.idAval = idAval;
    }

    public Integer getNota() {
        return nota;
    }

    public void setNota(Integer nota) {
        this.nota = nota;
    }

    public LocalDateTime getAvalData() {
        return avalData;
    }

    public void setAvalData(LocalDateTime avalData) {
        this.avalData = avalData;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }
}
