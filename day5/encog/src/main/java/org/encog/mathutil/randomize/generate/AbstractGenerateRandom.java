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
 * Provides a foundation for most random number generation.  This allows the nextDouble to generate
 * the other types.
 */
public abstract class AbstractGenerateRandom implements GenerateRandom {

    /**
     * {@inheritDoc}
     */
    @Override
    public int nextInt(final int low, final int high) {
        return (low + (int) (nextDouble() * ((high - low))));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public double nextDouble(final double high) {
        return nextDouble(0, high);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public double nextDouble(final double low, final double high) {
        return (low + (nextDouble() * ((high - low))));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int nextInt(final int range) {
        return nextInt(0, range);
    }
}
