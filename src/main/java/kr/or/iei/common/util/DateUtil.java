package kr.or.iei.common.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class DateUtil {
	/**
     * 게시글 작성일을 현재 시간과 비교하여 적절한 형식으로 반환합니다.
     *
     * @param postDate 게시글 작성일 ("yyyy-MM-dd HH:mm:ss" 형식)
     * @return "1분 전", "5분 전", "2시간 전", "3일 전", "1주 전", "2개월 전", "1년 전" 등
     */
    public static String calculateDate(String postDate) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime postDateTime;
        try {
            postDateTime = LocalDateTime.parse(postDate, formatter);
        } catch (Exception e) {
            // 날짜 형식이 올바르지 않을 경우 현재 시간으로 설정
            postDateTime = LocalDateTime.now();
        }

        LocalDateTime now = LocalDateTime.now();

        long seconds = ChronoUnit.SECONDS.between(postDateTime, now);
        if (seconds < 60) {
            return "1분 전";
        }

        long minutes = ChronoUnit.MINUTES.between(postDateTime, now);
        if (minutes < 60) {
            return minutes + "분 전";
        }

        long hours = ChronoUnit.HOURS.between(postDateTime, now);
        if (hours < 24) {
            return hours + "시간 전";
        }

        long days = ChronoUnit.DAYS.between(postDateTime, now);
        if (days <= 6) {
            return days + "일 전";
        }

        long weeks = days / 7;
        if (weeks < 4) {
            return weeks + "주 전";
        }

        long months = ChronoUnit.MONTHS.between(postDateTime, now);
        if (months < 12) {
            return months + "개월 전";
        }

        long years = ChronoUnit.YEARS.between(postDateTime, now);
        if (years > 1) {
            return "오래전";
        } else {
            return years + "년 전";
        }
    }
}
