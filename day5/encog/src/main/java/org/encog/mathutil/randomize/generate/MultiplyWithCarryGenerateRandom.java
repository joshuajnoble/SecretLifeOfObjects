/*
 * Encog(tm) Core v3.3 - Java Version
 * http://www.heatonresearch.com/encog/
 * https://github.com/encog/encog-java-core
 
 * Copyright 2008-2014 Heaton Research, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *   
 * For more information on Heaton Research copyrights, licenses 
 * and trademarks visit:
 * http://www.heatonresearch.com/copyright
 */
package org.encog.mathutil.randomize.generate;

/**
 * In Multiply with Carry (MWC) is a pseudo random number generator computer science, multiply-with-carry (MWC)
 * is a method invented by George Marsaglia for generating sequences of random integers based on an initial set
 * from two to many thousands of randomly chosen seed values. The main advantages of the MWC method are that it
 * invokes simple computer integer arithmetic and leads to very fast generation of sequences of random numbers
 * with immense periods.
 * <p/>
 * <p/>
 * This class was implemented using information from the following sources:
 * <p/>
 * http://www.javaprogrammingforums.com/blogs/helloworld922/11-complimentary-multiply-carry-better-way-generate-pseudo-random-numbers.html
 * http://en.wikipedia.org/wiki/Multiply-with-carry
 */
public class MultiplyWithCarryGenerateRandom extends AbstractBoxMuller {
    private long c;
    private long multiplier;
    private int n = 0;
    private int r;
    private final long[] seed;

    public MultiplyWithCarryGenerateRandom(final long seed) {
        this(new long[]{seed}, seed / 2, 64, 987657110L);
    }

    public MultiplyWithCarryGenerateRandom() {
        this(new long[]{System.currentTimeMillis()}, System.nanoTime(), 64, 987657110L);
    }

    public MultiplyWithCarryGenerateRandom(long[] seeds, final long carry, final int r, final long multiplier) {
        setR(r);
        setMultiplier(multiplier);
        this.seed = new long[r];
        if (seeds == null || seeds.length == 0) {
            seeds = new long[]{System.currentTimeMillis()};
        }

        final LinearCongruentialRandom rnd = new LinearCongruentialRandom(seeds[0]);
        this.c = (carry & 0xFFFFFFFFL) % multiplier;
        for (int i = 0; i < r; ++i) {
            if (i < seeds.length) {
                this.seed[i] = seeds[i] & 0xFFFFFFFFL;
            } else {
                this.seed[i] = rnd.nextInt() & 0xFFFFFFFFL;
            }
            if (this.seed[i] == 0xFFFFFFFFL) {
                this.seed[i] = 1L;
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public double nextDouble() {
        return (((long) next(26) << 27) + next(27))
                / (double) (1L << 53);
    }

    private int next(final int bits) {
        final long t = multiplier * seed[n] + c;
        final long d32 = t >>> 32;
        c = d32 + ((t & 0xFFFFFFFFL) >= 0xFFFFFFFFL - d32 ? 1L : 0L);
        seed[n] = 0xFFFFFFFEL - (t & 0xFFFFFFFFL) - (c - d32 << 32) - c & 0xFFFFFFFFL;
        final long result = seed[n];
        n = n + 1 & r - 1;
        return (int) (result >>> 32 - bits);
    }

    private void setMultiplier(final long theMultiplier) {
        this.multiplier = theMultiplier;
    }

    private void setR(int theR) {
        if (theR <= 0) {
            theR = 256;
        } else {
            boolean validR = true;
            long a = theR;
            while (a != 1 && validR) {
                if (a % 2 != 0) {
                    theR = 256;
                    validR = false;
                }
                a >>>= 1;
            }
        }
        this.r = theR;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public long nextLong() {
        return ((long) next(32) << 32) + next(32);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean nextBoolean() {
        return nextDouble() > 0.5;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public float nextFloat() {
        return (float) nextDouble();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int nextInt() {
        return (int) nextLong();
    }
}
