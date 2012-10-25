#include "AnalysisDistortion.h"
#include "TestRunner.h"

static int _testAnalysisDistortion(void) {
  SampleBuffer s = newSampleBuffer(1, 8);
  AnalysisFunctionData d = newAnalysisFunctionData();
  int i;
  for(i = 0; i < s->blocksize; i++) {
    s->samples[0][i] = 32767 * (i % 2 ? 1 : -1);
  }
  assertFalse(analysisDistortion(s, d));
  return 0;
}

static int _testAnalysisNotDistortion(void) {
  SampleBuffer s = newSampleBuffer(1, 8);
  AnalysisFunctionData d = newAnalysisFunctionData();
  assert(analysisDistortion(s, d));
  return 0;
}

TestSuite addAnalysisDistortionTests(void);
TestSuite addAnalysisDistortionTests(void) {
  TestSuite testSuite = newTestSuite("AnalysisDistortion", NULL, NULL);
  addTest(testSuite, "AnalysisDistortion", _testAnalysisDistortion);
  addTest(testSuite, "AnalysisNotDistortion", _testAnalysisNotDistortion);
  return testSuite;
}
