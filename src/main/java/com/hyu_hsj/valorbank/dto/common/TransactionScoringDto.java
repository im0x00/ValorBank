package com.hyu_hsj.valorbank.dto.ResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class TransactionScoringDto {
    private final Long transactionId;
    private final List<ScoreItemDto> scores;
}
