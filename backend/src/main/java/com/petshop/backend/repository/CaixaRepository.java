
package com.petshop.backend.repository;

import com.petshop.backend.model.Caixa;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CaixaRepository
        extends JpaRepository<Caixa, Integer> {
}
