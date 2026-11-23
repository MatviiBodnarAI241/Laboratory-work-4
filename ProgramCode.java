package ua.edu.op.dbmsartrainer;

/**
 * Виводить назву програмного продукту.
 */
public final class ProgramCode {

  /** Назва програмного продукту. */
  private static final String PRODUCT_NAME = "DBMS Architecture AR Trainer";

  private ProgramCode() {
  }

  /**
   * Точка входу.
   *
   * @param args аргументи командного рядка
   */
  public static void main(final String[] args) {
    System.out.println(PRODUCT_NAME);
  }
}
