package kr.or.iei.common.exception;

public class ApiLoginException extends RuntimeException {
	public ApiLoginException(String message) {
        super(message);
    }

    public ApiLoginException(String message, Throwable cause) {
        super(message, cause);
    }
}
