/*
 * Encog(tm) Examples v3.1 - Java Version
 * http://www.heatonresearch.com/encog/
 * http://code.google.com/p/encog-java/
 
 * Copyright 2008-2012 Heaton Research, Inc.
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
//package org.encog.examples.neural.predict.sunspot;

import java.text.NumberFormat;

import org.encog.ml.data.MLData;
import org.encog.ml.data.MLDataSet;
import org.encog.ml.data.basic.BasicMLData;
import org.encog.ml.data.temporal.TemporalDataDescription;
import org.encog.ml.data.temporal.TemporalMLDataSet;
import org.encog.ml.data.temporal.TemporalPoint;
import org.encog.neural.networks.BasicNetwork;
import org.encog.neural.networks.layers.BasicLayer;
import org.encog.neural.networks.training.Train;
import org.encog.neural.networks.training.propagation.resilient.ResilientPropagation;
import org.encog.util.EngineArray;
import org.encog.util.arrayutil.NormalizeArray;


  double[] wakeUp = {
9.405085, 6.6259727, 6.8627415, 6.215658, 7.6858435, 6.4165277, 8.005164, 
6.7792673, 7.307207, 7.235964, 6.811022, 6.643516, 7.918168, 8.0485115, 
6.1912107, 7.8951044, 6.7793484, 6.528061, 7.203441, 7.644987, 8.936059, 
9.509585, 6.3066683, 6.0236406, 6.5916524, 7.4394107, 7.9301004, 9.359396, 
10.633745, 6.4764547, 6.346476, 6.434755, 7.183704, 6.1622515, 9.488159, 
6.63307, 6.710671, 6.6009703, 7.261006, 6.6564145, 6.0515165, 10.194527, 
10.446146, 7.9949675, 6.759558, 6.324773, 6.6588535, 7.5701904, 11.531675, 
8.0565405, 7.533755, 6.800599, 7.9058714, 7.950596, 6.8258224, 8.082383, 
8.679849, 6.808704, 7.312463, 6.5759306, 6.4081225, 6.06631, 7.5706053, 
10.916197, 7.786803, 6.9537554, 7.633891, 7.649204, 7.180524, 10.061489 
          };
  
  public final static int STARTING_DAY = 0;
  public final static int WINDOW_SIZE = 70;
  public final static int TRAIN_START = 0;
  public final static int TRAIN_END = 10; // this is weeks
  public final static int EVALUATE_START = 49;
  public final static int EVALUATE_END = 70;
  
  // this is really high but makes training faster
  public final static double MAX_ERROR = 0.01;

  private double[] normalizedWakeups;
  private double[] closedLoopWakeups;
  
  public void normalizeWakeups(double lo, double hi) {
        NormalizeArray norm = new NormalizeArray();
        norm.setNormalizedHigh( hi);
        norm.setNormalizedLow( lo);

        // create arrays to hold the normalized sunspots
        normalizedWakeups = norm.process(wakeUp);
        closedLoopWakeups = EngineArray.arrayCopy(normalizedWakeups);
  }

  
  public MLDataSet generateTraining()
  {
    TemporalMLDataSet result = new TemporalMLDataSet(WINDOW_SIZE,1);
    
    TemporalDataDescription desc = new TemporalDataDescription(TemporalDataDescription.Type.RAW,true,true);
    result.addDescription(desc);
    
    for( int week = TRAIN_START; week < TRAIN_END; week++ )
    {
      for( int day = 0; day < 7; day++ )
      {
        TemporalPoint point = new TemporalPoint(1);
        point.setSequence((week * 7) + day);
        point.setData(0, this.normalizedWakeups[(week * 7) + day]);
        result.getPoints().add(point);
        
        print( day ); print( " " ); println(this.normalizedWakeups[(week * 7) + day]);
        
      }
    }
    
    result.generate();
    
    println(result.calculateActualSetSize());
    
    return result;
  }
  
  public BasicNetwork createNetwork()
  {
    BasicNetwork network = new BasicNetwork();
    network.addLayer(new BasicLayer(WINDOW_SIZE));
    network.addLayer(new BasicLayer(10));
    network.addLayer(new BasicLayer(1));
    network.getStructure().finalizeStructure();
    network.reset();
    return network;
  }
  
  public void train(BasicNetwork network, MLDataSet training)
  {
    final Train train = new ResilientPropagation(network, training);

    int epoch = 1;

    do {
      train.iteration();
      System.out
          .println("Epoch #" + epoch + " Error:" + train.getError());
      epoch++;
    } while(train.getError() > MAX_ERROR);
  }
  
  public void predict(BasicNetwork network)
  {
    NumberFormat f = NumberFormat.getNumberInstance();
    f.setMaximumFractionDigits(4);
    f.setMinimumFractionDigits(4);
    
    println("Year\tActual\tPredict\tClosed Loop Predict");
    
    for(int day=EVALUATE_START; day<EVALUATE_END; day++)
    {
      // calculate based on actual data
      MLData input = new BasicMLData(WINDOW_SIZE);
      for(int i=0;i<input.size();i++)
      {
        input.setData(i,this.normalizedWakeups[(day-WINDOW_SIZE)+i]);
      }
      MLData output = network.compute(input);
      double prediction = output.getData(0);
      this.closedLoopWakeups[day] = prediction;
      
      // calculate "closed loop", based on predicted data
      for(int i=0;i<input.size();i++)
      {
        input.setData(i,this.closedLoopWakeups[(day-WINDOW_SIZE)+i]);
      }
      output = network.compute(input);
      double closedLoopPrediction = output.getData(0);
      
      // display
      println((day)
          +"\t"+f.format(this.normalizedWakeups[day])
          +"\t"+f.format(prediction)
          +"\t"+f.format(closedLoopPrediction)
      );
      
    }
  }
  
  public void run()
  {
    normalizeWakeups(0.1,0.9);
    BasicNetwork network = createNetwork();
    MLDataSet training = generateTraining();
    train(network,training);
    predict(network);
    
  }
  
  
void setup()
{
  run();
}

void loop()
{
}

