package org.x96.sys.lexer.visitor.factory;

import org.x96.sys.buzz.Buzz;
import org.x96.sys.lexer.tokenizer.Tokenizer;
import org.x96.sys.lexer.visitor.Visitor;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public final class ReflectiveVisitorFactory {
    private static Constructor<? extends Visitor> build(Class<? extends Visitor> cls) {
        try {
            return cls.getConstructor(Tokenizer.class);
        } catch (NoSuchMethodException e) {
            // TODO
            throw new Buzz(123, "?", "Não foi possível construir visitante");
        }
    }

    public static Visitor happens(Class<? extends Visitor> cls, Tokenizer tokenizer) {
        try {
            return build(cls).newInstance(tokenizer);
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException e) {
            // TODO
            throw new Buzz(1234, "??", "Não foi possível construir visitante");
        }
    }
}
