
package com.petshop.backend.repository;

import com.petshop.backend.model.Avaliacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AvaliacaoRepository
        extends JpaRepository<Avaliacao, Integer> {
}
