package org.x96.sys.visitor;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.x96.sys.lexer.visitor.BuildInfo;

public class BuildInfoTest {

    @Test
    void testConstantsNotNullOrEmpty() {
        assertNotNull(BuildInfo.VERSION, "VERSION não pode ser nulo");
        assertFalse(BuildInfo.VERSION.isEmpty(), "VERSION não pode ser vazio");

        assertNotNull(BuildInfo.BUILD_TIMESTAMP, "BUILD_TIMESTAMP não pode ser nulo");
        assertFalse(BuildInfo.BUILD_TIMESTAMP.isEmpty(), "BUILD_TIMESTAMP não pode ser vazio");

        assertNotNull(BuildInfo.BUILD_USER, "BUILD_USER não pode ser nulo");
        assertFalse(BuildInfo.BUILD_USER.isEmpty(), "BUILD_USER não pode ser vazio");

        assertNotNull(BuildInfo.BUILD_HOST, "BUILD_HOST não pode ser nulo");
        assertFalse(BuildInfo.BUILD_HOST.isEmpty(), "BUILD_HOST não pode ser vazio");

        assertNotNull(BuildInfo.BUILD_OS, "BUILD_OS não pode ser nulo");
        assertFalse(BuildInfo.BUILD_OS.isEmpty(), "BUILD_OS não pode ser vazio");

        assertNotNull(BuildInfo.JAVA_VERSION, "JAVA_VERSION não pode ser nulo");
        assertFalse(BuildInfo.JAVA_VERSION.isEmpty(), "JAVA_VERSION não pode ser vazio");
    }

    @Test
    void testVersionNumbersNonNegative() {
        assertTrue(BuildInfo.VERSION_MAJOR >= 0, "VERSION_MAJOR deve ser >= 0");
        assertTrue(BuildInfo.VERSION_MINOR >= 0, "VERSION_MINOR deve ser >= 0");
        assertTrue(BuildInfo.VERSION_PATCH >= 0, "VERSION_PATCH deve ser >= 0");
    }

    @Test
    void testVersionFormatIsCommitLike() {
        String version = BuildInfo.VERSION;
        // Aceita commit hash com sufixo opcional (-dirty, -SNAPSHOT etc.)
        assertTrue(
                version.matches("[0-9a-f]+(-[a-zA-Z0-9]+)?"),
                "VERSION deve parecer um hash ou hash-sufixo (ex: 190d77e, 190d77e-dirty)");
    }

    @Test
    void testTimestampFormat() {
        String ts = BuildInfo.BUILD_TIMESTAMP;
        // Formato ISO-8601 UTC esperado: yyyy-MM-ddTHH:mm:ssZ
        assertTrue(
                ts.matches("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z"),
                "BUILD_TIMESTAMP deve estar em formato ISO-8601 UTC");
    }

    @Test
    void testJavaVersionContainsVersionNumber() {
        String jv = BuildInfo.JAVA_VERSION;
        assertTrue(
                jv.matches(".*\"?\\d+\\.\\d+(?:\\.\\d+)?\"?.*"),
                "JAVA_VERSION deve conter número de versão (ex: 23.0.1 ou \"23.0.1\")");
    }
}
