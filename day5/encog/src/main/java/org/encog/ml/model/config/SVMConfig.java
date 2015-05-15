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
package org.encog.ml.model.config;

import org.encog.EncogError;
import org.encog.ml.data.versatile.VersatileMLDataSet;
import org.encog.ml.data.versatile.columns.ColumnType;
import org.encog.ml.data.versatile.normalizers.IndexedNormalizer;
import org.encog.ml.data.versatile.normalizers.OneOfNNormalizer;
import org.encog.ml.data.versatile.normalizers.RangeNormalizer;
import org.encog.ml.data.versatile.normalizers.strategies.BasicNormalizationStrategy;
import org.encog.ml.data.versatile.normalizers.strategies.NormalizationStrategy;
import org.encog.ml.factory.MLMethodFactory;
import org.encog.ml.factory.MLTrainFactory;

/**
 * Config class for EncogModel to use an SVM.
 */
public class SVMConfig implements MethodConfig {
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public String getMethodName() {
		return MLMethodFactory.TYPE_SVM;
	}
	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public String suggestModelArchitecture(VersatileMLDataSet dataset) {
		int outputColumns = dataset.getNormHelper().getOutputColumns().size();
		
		if( outputColumns>1 ) {
			throw new EncogError("SVM does not support multiple output columns.");
		}
		
		ColumnType ct = dataset.getNormHelper().getOutputColumns().get(0).getDataType();
		StringBuilder result = new StringBuilder();
		result.append("?->");
		if( ct==ColumnType.nominal ) {
			result.append("C");
		} else {
			result.append("R");
		}
		result.append("->?");
		return result.toString();
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	public NormalizationStrategy suggestNormalizationStrategy(VersatileMLDataSet dataset, String architecture) {
		int outputColumns = dataset.getNormHelper().getOutputColumns().size();
		
		if( outputColumns>1 ) {
			throw new EncogError("SVM does not support multiple output columns.");
		}
		
		ColumnType ct = dataset.getNormHelper().getOutputColumns().get(0).getDataType();
		
		BasicNormalizationStrategy result = new BasicNormalizationStrategy();
		result.assignInputNormalizer(ColumnType.continuous,new RangeNormalizer(0,1));
		result.assignInputNormalizer(ColumnType.nominal,new OneOfNNormalizer(0,1));
		result.assignInputNormalizer(ColumnType.ordinal,new OneOfNNormalizer(0,1));
		
		result.assignOutputNormalizer(ColumnType.continuous,new RangeNormalizer(0,1));
		result.assignOutputNormalizer(ColumnType.nominal,new IndexedNormalizer());
		result.assignOutputNormalizer(ColumnType.ordinal,new OneOfNNormalizer(0,1));
		return result;
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	public String suggestTrainingType() {
		return MLTrainFactory.TYPE_SVM;
	}


	@Override
	public String suggestTrainingArgs(String trainingType) {
		return "";
	}
	
	@Override
	public int determineOutputCount(VersatileMLDataSet dataset) {
		return dataset.getNormHelper().calculateNormalizedOutputCount();
	}
}
